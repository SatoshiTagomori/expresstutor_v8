<template>
    <div>
        <ul class='subscriptions'>
            <li class='subscription_list' v-for="sub in subscriptions">
                <ul class='course'>
                    <li class='comment'><span>{{sub.comment}}</span></li>
                    <li class='course_name'>{{sub.name}}</li>
                    <li class='course_price'>&yen;{{Math.round(sub.price).toLocaleString()}}</li>
                    <li class='course_tickets'>毎月{{sub.tickets}}チケット</li>
                    <li class='course_valid_date'>有効期限：{{sub.valid_date}}</li>
                </ul>
                <button v-if='payment && course_id!=sub.id' class='btn btn-primary' v-on:click='purchase(sub.id)'>{{sub.name}}で契約</button>
                <button v-if='payment && course_id==sub.id' class='btn btn-info' aria-disabled="true" >契約中</button>
            </li>
        </ul>
        <svg :width='arrow_width' :height='arrow_height'>
            <path :d='d' fill='royalblue'></path>
            <text x="50%" y="40%"  text-anchor="middle" dominant-baseline="central" fill='khaki'>
                それでもチケットが足りない時は
            </text>
        </svg>
        <ul class='subscriptions'>
            <li class='subscription_list' v-for="sub in non_subscriptions">
                <ul class='course'>
                    <li class='comment'><span>{{sub.comment}}</span></li>
                    <li class='course_name'>{{sub.name}}</li>
                    <li class='course_price'>&yen;{{Math.round(sub.price).toLocaleString()}}</li>
                    <li class='course_tickets'>{{sub.tickets}}チケット</li>
                    <li class='course_valid_date'>有効期限：{{sub.valid_date}}</li>
                </ul>
                 <button v-if='payment && course_id!=sub.id' class='btn btn-primary' v-on:click='purchase(sub.id)'>{{sub.name}}を購入</button>
            </li>
        </ul>
        <button v-if='payment && course_id' class='btn btn-danger' v-on:click='delete_subscription'>現在契約中のプランを解約</button>
    </div>
</template>

<script>
    import Axios from "axios"
    export default{
        data(){
            return{
                subscriptions:{},
                non_subscriptions:{},
                arrow_width:0,
                arrow_height:0,
                d:'',
                payment:false,
                course_id:null
            }
        },
        methods:{
            getCourse(){
                Axios.get('/api/subscriptions').then(
                    response =>{
                        this.subscriptions = response.data;
                    }
                );
                Axios.get('/api/non_subscriptions').then(
                    response =>{
                        this.non_subscriptions = response.data;
                        this.$nextTick(()=>{
                            this.bi_chousei();
                        })
                    }
                );
            },
            purchase(course_id){
                var stripe = Stripe(this.api_key)
                Axios.post('/create_checkout_session',{
                    "authenticity_token":document.querySelector("meta[name=csrf-token]").getAttribute("content"),
                    "course_id": course_id
                },{
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).then(
                    response=>{
                       stripe.redirectToCheckout({ sessionId: response.data.id });
                    }
                ).catch(
                    response=>{
                        alert(response)        
                    }
                )
                
            },
            setStyle(){
                this.arrow_width = this.$el.clientWidth
                this.arrow_height = 70
                this.d = 'M '+this.arrow_width*0.05+' 0 v 30 h -100 v 20 L '+(this.arrow_width/2-50)+' '+this.arrow_height+' L '+(this.arrow_width/2+50)+' '+this.arrow_height+' L '+this.arrow_width+' 50 v -20 h -'+this.arrow_width*0.05+' v -30 z'
                this.bi_chousei();
            },
            bi_chousei(){
                let ls = this.$el.getElementsByClassName('subscription_list');
                Object.keys(ls).forEach(function(key){
                   let comment = ls[key].getElementsByClassName('comment')[0];
                   let w = ls[key].clientWidth;
                   if( w >600){
                       comment.style.top = '-150px';
                   }else{
                       comment.style.top = '-120px';   
                   }
                });
            },
            delete_subscription(){
                var stripe = Stripe(this.api_key)
                if(confirm('本当に解約しますか？')){
                    Axios.post('/payment/delete/subscriptions',{
                        "authenticity_token":document.querySelector("meta[name=csrf-token]").getAttribute("content")
                    }).then(
                        response=>{
                           //alert('解約しました');
                           location.href='/payment';
                        }
                    ).catch(
                        response=>{
                            console.log(response)        
                        }
                    )
                }
            }
        },
        mounted(){
            this.getCourse()
            //購入ボタンを表示するかどうか
            this.$el.parentNode.getAttribute('payment')==='true' ? this.payment=true:this.payment=false;
            //購入ボタンを表示する場合はstripeのAPIキーが必要になる
            this.payment === true ? this.api_key = this.$el.parentNode.getAttribute('api_key') : this.api_key=false
            //現在のコースを取得する
            this.payment === true ? this.course_id = this.$el.parentNode.getAttribute('contract_course_id') : this.course_id = false
            this.$nextTick(()=>{
                this.setStyle()
            })
            window.addEventListener('resize',this.setStyle,false);
        }
    }
</script>

<style scoped>
    ul{
        padding:0;
    }
    li{
        list-style:none;
    }
    .subscriptions{
        display:flex;
    }
    .subscription_list{
        flex:1;
        text-align:center;
        background-color:darkblue;
        color:black;
    }
    .subscription_list{
        overflow:hidden;
        position:relative;
        border:solid 3px blue;
        border-radius:10px;
        margin:5px;
        color:white;
    }
    .course>li{
        font-weight:bold;
        font-family: "Arial", "メイリオ";
    }
    .course_name{
        font-size:30px;
        text-align:center;
        margin: 50px 0 20px 0;
    }
    .course_price{
        font-size:30px;
        font-weight:bold;
        color:pink;
    }
    .comment{
        text-align:left;
        text-indent:1em;
        padding:10px 0;
        background-color:pink;
        color:black;
        font-size:16px;
        padding:0;
        position:absolute;
        height:150px;
        width:150%;
        transform:rotate(-5deg);
        left:-20px;
        top:-120px;
    }
    .comment>span{
        position:absolute;
        bottom:0;
    }
    @media screen and (max-width:768px){
        .subscriptions{
            display:block;
        }
    }
    text{
        font-size:20px;
        display:block;
        width:100%;
    }
</style>