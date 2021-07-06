<template>
    <div>
        <ul>
            <li v-for='(pic,key) in pics' :style="{backgroundImage:'url('+require('../../images/'+pic)+')'}">
               <pre>{{messages[key]}}</pre>
            </li>
        </ul>
    </div>
</template>

<script>
    export default{
        data(){
            return{
                messages:[],
                pics:[]
            }
        },
        methods:{
            setStyle(){
                let thisObj = this
                this.ul.style.width = this.lis.length * this.div.clientWidth + 'px';
                this.page=0;
                this.ul.style.left='0px';
                Object.keys(this.lis).forEach((key)=>{
                  thisObj.lis[key].style.width = thisObj.$el.clientWidth + 'px'; 
                })
                this.autoSlide();
            },
            autoSlide(){
                clearInterval(this.interval_id)
                this.slide()
                this.interval_id =setInterval(()=>{
                    this.page++;
                    if(this.page<this.lis.length){
                        this.slide();
                    }else{
                        clearInterval(this.interval_id);
                        this.page = this.lis.length-1;
                    }
                },3000)
            },
            slide(){
                let thisObj = this
                this.ul.style.left=-this.page * this.$el.clientWidth +'px';
                Object.keys(this.lis).forEach((key)=>{
                  thisObj.lis[key].getElementsByTagName('pre')[0].style.top='-250px';
                })
                setTimeout(()=>{
                    let span = this.lis[this.page].getElementsByTagName('pre')[0];
                    span.style.top = '250px';
                },500)
            }
        },
        created(){
          this.interval_id;
          this.page=0;
        },
        mounted(){
            this.div = this.$el
            this.pics = JSON.parse(this.$el.parentNode.attributes.pics.nodeValue)
            this.messages = JSON.parse(this.$el.parentNode.attributes.messages.nodeValue)
            this.ul = this.div.getElementsByTagName('ul')[0];
            this.lis = this.ul.getElementsByTagName('li');
            this.$nextTick(()=>{
                this.setStyle();
            })
            window.addEventListener('resize',this.setStyle,false);
        }
    }
</script>

<style scoped>
    div{
        overflow:hidden;
    }
    pre{
        display:inline-block;
        height:250px;
        color:white;
        position:relative;
        top:-250px;
        font-size:50px;
        transition: top 1s ease;
        transform:rotate(-7deg);
        left:30px;
        text-shadow    : 
           2px  2px 1px #003366,
          -2px  2px 1px #003366,
           2px -2px 1px #003366,
          -2px -2px 1px #003366,
           2px  0px 1px #003366,
           0px  2px 1px #003366,
          -2px  0px 1px #003366,
           0px -2px 1px #003366;   
    }
    ul{
        width:100%;
        padding:0;
        position:relative;
        transition: left 1s ease;
    }
    ul:after{
        content:'';
        display:block;
        clear:both;
    }
    li{
        height:500px;
        opacity: 0.8;
        float:left;
        background-repeat:no-repeat;
        background-position:center;
        background-size:cover;
        list-style:none;
    }
  
</style>