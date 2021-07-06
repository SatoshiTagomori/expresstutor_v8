<template>
    <svg xmlns="http://www.w3.org/2000/svg" :width="width" :height="height">
        <defs>
            <linearGradient id="g0">
                <stop offset="0.2" stop-color="royalblue"/>
                <stop offset="0.8" stop-color="limegreen"/>
            </linearGradient>
        </defs>
        <path :d="d" fill="url(#g0)"></path>
    </svg>
</template>

<script>
    export default {
      data(){
          return{
              d:"M 0 0 L 0 400 C 200 350 , 300 350 ,500 400 S 800 450 ,1000 400 L 1000 0",
              width:'100%',
              height:'800px'
          }
      },
      methods:{
            setStyle(){
                clearInterval(this.interval_id);
                let ww = window.innerWidth;
                this.width = ww+'px'
                this.interval_id = setInterval(()=>{
                    let posi = 400 + Math.sin(this.sec/15/Math.PI)*100;
                    let nega = 400 - Math.sin(this.sec/15/Math.PI)*100;
                    
                    this.d = "M 0 0 L 0 " + posi + " C "+ww/5+" "+nega+" , "+ww/3.5+" "+ nega +" ,"+ww/2+" 400 S "+ww/1.2+" "+ posi +" ,"+ww+" "+nega+" L "+ww+" 0"
                    this.sec++;
                },40)
            }  
      },
      created(){
        this.sec = 0;  
        this.interval_id;
      },
      mounted(){
          this.svg = this.$el
          this.setStyle();
          window.addEventListener('resize',this.setStyle,false);
      }
    }
</script>

<style scoped>
    svg{
        opacity:0.2;
        position:fixed;
        top:0;
        width:100%;
        z-index:-1;
    }
</style>