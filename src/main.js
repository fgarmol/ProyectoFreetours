import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap';
import 'bootstrap-notify';
import $ from 'jquery';
import './assets/styles/colors.css';

window.$ = $;

createApp(App).use(router).mount('#app');
