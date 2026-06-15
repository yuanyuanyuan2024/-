import Vue from 'vue';
import App from './App.vue';
import router from './router';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import 'babel-polyfill';

/*
* Vue.prototype.$axios = axios;

给Vue函数添加一个原型属性$axios 指向Axios

这样做的好处是在vue实例或组件中不用再去重复引用Axios
直接用this.$axios就能执行axios 方法了
*
* */

import api from './api/index.js';
Vue.prototype.$api = api;

let globalData={
    userInfo:{
        nickname:''
    }
};
let sta={
    isLogin:false,
    adminName:''
};
Vue.prototype.$sta = sta;

Vue.prototype.$globalData=globalData;


/* 让它少提示一个错误信息 */
Vue.config.productionTip = false;

Vue.use(ElementUI, {
    size: 'medium'
});


router.beforeEach((to, from, next) => {
    document.title = `${to.meta.title}`;
    // console.log(to.path,'userInfo:',Vue.prototype.$globalData.userInfo);
    const nickname = Vue.prototype.$globalData.userInfo.nickname;
    if (!nickname
        &&(to.path === '/me'
        || to.path === '/message'
        || to.path === '/release'
        || to.path === '/order')) {
        api.getUserInfo().then(res=>{
           console.log('getUserInfo:',res);
           if(res.status_code!==1){
               next('/login');
           }else {
               res.data.signInTime=res.data.signInTime.substring(0,10);
               Vue.prototype.$globalData.userInfo=res.data;
               next();
           }
        }).catch(e=>{
            next('/login');
        });

    }else{
        next();
    }
});

new Vue({
    router,
    render: h => h(App)
}).$mount('#app');
