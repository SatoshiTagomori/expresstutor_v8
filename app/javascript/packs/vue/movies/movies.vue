<template>
    <ul>
        <li v-for="movie in movies">
            <iframe :height="iframe_height" :src="movie" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </li>
    </ul>
</template>
<script>
    export default{
        data(){
            return{
                message:'hello',
                movies:[],
                iframe_width:400,
                iframe_height:226
            }
        },
        methods:{
            setStyle(){
                this.$nextTick(()=>{
                    let li = this.$el.getElementsByTagName('iframe')[0].clientWidth
                    this.iframe_height =li * 226/400
                })
   
            }
        },
        mounted(){
            this.$nextTick(()=>{
                this.movies = (JSON.parse(this.$el.parentNode.attributes.movies.value))
                this.setStyle() 
            })
            window.addEventListener('resize',this.setStyle,false);
        }
    }
</script>
<style scoped>
    ul{
        padding:0;
        width:100%;
        display:flex;
    }
    li{
        list-style:none;
        flex:1;
        padding:10px 0;
    }
    iframe{
        display:block;
        width:98%;
        box-sizing:border-box;
        border:solid 2px gray;
    }
    li:nth-child(2n)>iframe{
        margin-left:auto;
    }
    li:nth-child(2n+1)>iframe{
        margin-right:auto;
    }
    
    @media screen and (max-width:768px){
        ul{
            display:block;
        }
        li{
            width:100%;
        }
        iframe{
            width:100%;
        }
    }
</style>