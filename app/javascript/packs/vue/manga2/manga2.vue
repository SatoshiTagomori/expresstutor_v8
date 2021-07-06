<template>
    <div class='manga_wrapper'>
        <ul>
            <li v-for='(pic,key) in pics'>
                <div class='manga_pic' :style='backgrounds[key]'>
                    <img class='arrow' :src="arrow">
                </div>
                <p v-if='typeof(key)==="string"'>
                    <pre>{{key}}</pre>
                </p>
            </li>
        </ul>
    </div>
</template>

<script>
    export default{
        data(){
            return{
                pics:'',
                arrow: require('./arrow.png'),
                aspectratio: 0.537,
                backgrounds:[],
                threshold:768
            }
        },
        methods:{
            setStyle(e){
                if(e!==undefined){
                    setTimeout(()=>{this.setStyleLogic();},100)
                }else{
                    this.setStyleLogic();
                }
            },
            setStyleLogic(){
                if(this.isSmallWindow()){
                    this.ul.style.width = this.div.clientWidth * this.lis.length +'px';
                }else{
                    this.ul.style.width = '100%';
                }
                this.change_manga_pic_height();
                this.ul.style.left='0px';  
            },
            setUlWidth(){
                if(this.isSmallWindow()){
                    this.ul.style.width = this.div.clientWidth * this.lis.length +'px';
                }else{
                    this.ul.style.width = '100%';
                }
            },
            isSmallWindow(){
              return window.innerWidth <= Number(this.threshold);
            },
            change_manga_pic_height(){
                let thisObj = this
                let w = this.lis[0].clientWidth;
                //高さを変更する
                Object.keys(this.manga_pics).forEach((key)=>{thisObj.manga_pics[key].style.height = w * this.aspectratio + 'px'})
                let arrows  = this.div.querySelectorAll('.arrow');
                if(this.isSmallWindow()){
                    Object.keys(arrows).forEach((key)=>{
                        arrows[key].style.top = w * this.aspectratio - 40 + 'px';
                        arrows[key].style.left = w -40 +'px';
                        arrows[key].style.transform = 'rotate(0deg)';
                    });
                }else{
                    Object.keys(arrows).forEach((key)=>{
                        if(key%2===0){
                            arrows[key].style.top = (w * this.aspectratio)/2 -10 + 'px';
                            arrows[key].style.left = w  +'px';
                        }else{
                            arrows[key].style.top = (w * this.aspectratio) + 'px';
                            arrows[key].style.left = -25  +'px';
                            arrows[key].style.transform = 'rotate(135deg)';
                        }
                    });
                    
                }
                
            },
            showImages(){
                let thisObj = this
                let sa = (window.scrollY - this.$el.parentNode.getBoundingClientRect().top)
                if(Object.keys(this.pics).length > Object.keys(this.backgrounds).length && sa>-window.innerHeight){
                    Object.keys(this.pics).forEach(function(key){
                        thisObj.backgrounds[key] = {backgroundImage: 'url('+require('../../images/'+thisObj.pics[key])+')'}
                    })
                }
            },
            moveStart(e){
                //e.preventDefault();
                this.onMove=true;
                if (e.type === 'mousedown') this.startX = e.clientX;
                if (e.type === 'touchstart') this.startX = e.targetTouches[0].clientX;
                
            },
            movePics(e){
                //e.preventDefault();
                if(this.isSmallWindow() && this.onMove){
                    let sabun = 0;
                    if (e.type === 'mousemove'){sabun = this.startX - e.clientX;}
                    if (e.type === 'touchmove'){sabun = this.startX - e.targetTouches[0].clientX;}
                    sabun > 0 ? this.direction = 'left':this.direction='right';
                    let newLeft = -this.page * this.div.clientWidth -sabun;
                    this.ul.style.left = newLeft + 'px';
                    this.dontOver();
                }
            },
            dontOver(){
              let leftNow = Number(this.ul.style.left.replace('px',''))
              if(leftNow > 0) this.ul.style.left = '0px';
              if(leftNow < -(this.lis.length-1) * this.div.clientWidth) this.ul.style.left = -(this.lis.length-1) * this.div.clientWidth+'px';
            },
            moveEnd(e){
                //e.preventDefault();
                this.onMove = false;
                if(this.isSmallWindow()){
                    if(this.direction === 'left'){
                        this.page++
                    }else{
                        this.page--
                    }
                    if(this.page < 0) this.page = 0;
                    if(this.page > this.lis.length-1) this.page = this.lis.length-1;
                    this.ul.style.transition = 'left 1s ease';
                    this.ul.style.left = - this.page * this.div.clientWidth + 'px';
                    setTimeout(()=>{this.ul.style.transition='left 0s'},100)
                }
            },
            getElements(){
                this.element = this.$el.parentElement;
                this.div = this.element.getElementsByClassName('manga_wrapper')[0];
                this.ul = this.div.getElementsByTagName('ul')[0];
                this.lis = this.ul.getElementsByTagName('li');
                this.manga_pics = this.div.getElementsByClassName('manga_pic');
            },
            addEvent(element,events,func){
                Object.keys(events).forEach((key)=>{
                    element.addEventListener(events[key],func,false);
                })
            }
        },
        created(){
          this.onMove=false;
          this.startX=0;
          this.page=0;
          this.direction=null;
        },
        mounted(){
            //全ての属性を取得してプロパティとして追加する
            new get_all_attributes(this);
            //マウントした要素を取得
            this.getElements();
            this.$nextTick(()=>{
                this.showImages()
                //オブザーバーの使い方がよくわからんので、とりあえず１００ミリ秒遅らせる
                setTimeout(()=>{this.setStyle()},100);
            })
            //スクロールした時に画像が読み込まれるようにする
            this.addEvent(window,['scroll'],this.showImages);
            //画面をリサイズしたときにスタイルを再度セット
            this.addEvent(window,['resize'],this.setStyle);
            //押した時のイベント
            this.addEvent(this.div,['mousedown','touchstart'],this.moveStart);
            //移動した時のイベント
            this.addEvent(this.div,['mousemove','touchmove'],this.movePics);
            //移動修了
            this.addEvent(this.div,['mouseup','touchend'],this.moveEnd);
        }
    }
    //属性を全部取得する
    class get_all_attributes{
        constructor(obj){
            let thisObj = this
            let el = obj.$el.parentNode;
            Object.keys(el.attributes).forEach(function(key){
              let property_name = (el.attributes[key].localName)
              let values = thisObj.get_object(el.attributes[key].nodeValue)
              if(property_name !=='class' && property_name !=='id'){
                  if(typeof(values)==='string'){
                      eval('obj.'+String(property_name)+'=\''+values+'\'');
                  }else{
                      eval('obj.'+String(property_name)+'='+el.attributes[key].nodeValue);
                  }
              }
            })
        }
        get_object(text){
            try{return JSON.parse(text);}catch(e){return text;}
        }
    }

 
</script>

<style scoped>

    .manga_wrapper:after{
        content:'';
        display:block;
        clear:both;
        position:relative;
    }
    ul{
        padding:0;
        box-sizing:border-box;
    }
    li{
        list-style:none;
        margin-bottom:10px;
    }
    .manga_pic{
        width:100%;
        background-size:contain;
        background-repeat:no-repeat;
        background-position:center;
        box-sizing:border-box;
    }
    p{
        padding: 0 10px;
        text-align:center;
        height:40px;
    }
    .arrow{
        width:25px;
        position:relative;
    }
    li:last-child .arrow{
        display:none;
    }

@media screen and (min-width:768px){
    ul{
        position:relative;
        left:0;
    }
    li{
       width:49%; 
    }
    li:nth-child(2n+1){
        float:left;
    }
    li:nth-child(2n){
        float:right;
    }

}
    

@media screen and (max-width:768px){
    
    .manga_wrapper{
        overflow:hidden;
    }
    
    ul{
        display:flex;
        position:relative;
        left:0;
    }
    
    li{
        float:none;
        width:100%;
    }
    .manga_pic{
        width:100%;
    }
    
}
</style>