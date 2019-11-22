import { hot } from 'react-hot-loader/root' 
import App from 'framework/app'
import configureStore from './store/configureStore'
import createRouter from './router'
import Main from './view/main'

const Entry = EASY_ENV_IS_DEV ? hot(Main) : Main;

export default new App({
  Entry,
  createRouter,
  configureStore
}).bootstrap();
