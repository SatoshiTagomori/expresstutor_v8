<template>

</template>

<script>
    export default{
        data(){
            return{
                messages:['あああ\nああああ',
                        'いいいいいいいいい',
                        'ううううううう',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        'えええええええええええええ\nえええええええええええええええええええええ\nええええええええええええええええええええええええええ',
                        ]
            }
        },
        mounted(){
            let lis = this.$el.getElementsByTagName('li');
            this.$nextTick(()=>{
                Object.keys(lis).forEach(function(key){
                    let li = lis[key];
                    //li.style.transform='rotate('+(Math.floor(Math.random()*40)-20)+'deg)'
                })
            })
        }
    }
</script>

<style scoped>


    ul{
        padding:0;
        height:500px;
    }
    li{
        list-style:none;
        border:solid 2px gray;
        border-radius:200px;
        display:inline-block;
        padding:10px;
    }

</style>