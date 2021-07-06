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
                pics:[]
            }
        },
        methods:{
            
            ul_slide(){
                this.$el.getElementsByTagName('ul')[0].style.left='-100%';
            }  
        },
        mounted(){
            new get_all_attributes(this);
            this.$nextTick(()=>{
                setTimeout(()=>{
                    this.ul_slide();
                },3000)
                
            })
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
    div{
        width:100%;
        overflow:hidden;
        position:relative;
    }
    ul{
        padding:0;
        display:flex;
        width:200%;
        position:relative;
        left:0px;
        transition:left 1s ease;
    }
    li{
        list-style:none;
        height:500px;
        background-size:100%;
        background-position:top;
        background-repeat:no-repeat;
        background-size:cover;
        flex:1;
    }
    pre{
        display:inline-block;
        height:250px;
        color:white;
        position:relative;
        font-size:50px;
        transition: top 1s ease;
        transform:rotate(-7deg);
        left:30px;
        top:250px;
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

  
</style>