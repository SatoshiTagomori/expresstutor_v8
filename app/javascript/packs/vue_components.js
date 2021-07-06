import { createApp } from "vue/dist/vue.esm-bundler.js";


import WaveBack from "./vue/wave_back/wave_back.vue";
import Carousel from "./vue/carousel/carousel.vue";
import Course from "./vue/course/course.vue";
import Movies from "./vue/movies/movies.vue";
import Manga2 from './vue/manga2/manga2.vue';
import SlideCard from './vue/slide_card/slide_card.vue';


document.addEventListener("DOMContentLoaded", () => {
  
   
   setApp(Carousel,'carousel');
   setApp(Course,'course');
   setApp(Movies,'movies');
   setApp(WaveBack,'wave_back');
   setApp(Manga2,'manga2')
   setApp(SlideCard,'slide_card');

   function setApp(Obj,cl){
      //let elements = document.getElementsByClassName(cl);
      let elements;
      // お約束を取り付けたい処理にPromise
      new Promise((resolve) => {
        //1秒後に実行する処理
          elements = document.getElementsByClassName(cl);
          resolve();
      }).then(() => {
         Object.keys(elements).forEach(function(key){
            if(elements[key]!==undefined){
               elements[key].setAttribute('id',cl+'_'+key);
               createApp(Obj).mount('#' +(elements[key].id));
            }
         })

      });

   }
  
});
