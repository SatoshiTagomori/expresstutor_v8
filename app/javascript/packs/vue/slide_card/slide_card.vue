<template>
    <div class='wrapper'>
        <div class='pic' :style='background'></div>
        <h4>
            <span v-for='title in titles'>{{title}}</span>
        </h4>
        <p v-html='content'>
        </p>
    </div>
</template>

<script>
    export default{
        data(){
          return{
              background:'',
              titles:'',
              content:''
          }  
        },
        methods:{
            setStyle(){
                let main_width = this.$el.parentElement.clientWidth;
                let pic_width = this.$el.parentElement.getElementsByClassName('pic')[0].clientWidth;
                let w = main_width - pic_width-10;
                if(this.isSmallWindow()){
                    this.$el.parentElement.getElementsByTagName('h4')[0].style.width='100%'
                    this.$el.parentElement.getElementsByTagName('p')[0].style.width='100%'            
                }else{
                    this.$el.parentElement.getElementsByTagName('h4')[0].style.width=w +'px'
                    this.$el.parentElement.getElementsByTagName('p')[0].style.width=w +'px'
                }
            },
            isSmallWindow(){
                return this.$el.parentElement.clientWidth < 758;
            }
        },
        mounted(){
            new get_all_attributes(this);
            this.$nextTick(()=>{
                this.background={backgroundImage:'url('+require('../../images/'+this.pic)+')'}
                this.setStyle();
            })
            window.addEventListener('resize',this.setStyle,false);
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
    .wrapper{

    }
    .wrapper:after{
        clear:both;
        display:block;
        content:'';
    }
    .pic{
        width:150px;
        height:150px;
        background-size:cover;
        background-repeat:no-repeat;
        border-radius:50%;
        float:left;
        margin:0 auto;
    }
    h4{
        float:right;
        font-weight:bold;
        color:darkblue;
        padding:10px;
    }
    p{
        float:right;
        clear:right;
        font-size:20px;
        padding:10px;
    }
    
@media screen and (max-width:768px){
    .pic{
        float:none;
        display:block;
        margin:0 auto;
    }
    h4,p{
        float:none;
    }
}

</style>