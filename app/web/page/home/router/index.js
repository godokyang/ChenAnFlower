import Home from './Home';
import Manage from './Manage'
import OrderConfirm from './OrderConfirm'
import OrderList from './OrderList'
import RootOrderList from './RootOrderList'
import OrderDetail from './OrderDetail'
import Login from '../router/Login'
import EditGoods from './EditGoods';

const NotFound = () => {
  return (
    <Route render={({ staticContext }) => {
      if (staticContext) {
        staticContext.status = 404;
      }
      return (
        <div>
          <h1>404 : Not Found</h1>
        </div>
      );
    }}/>
  );
};


export default function createRouter() {
  return [
    {
      path: '/web/home',
      component: Home
    },
    {
      path: '/web/manage',
      component: Manage
    },
    {
      path: '/web/orderConfirm',
      component: OrderConfirm
    },
    {
      path: '/web/orderList',
      component: OrderList
    },
    {
      path: '/web/rootOrderList',
      component: RootOrderList
    },
    {
      path: '/web/orderDetail',
      component: OrderDetail
    },
    {
      path: '/web/editGoods',
      component: EditGoods
    },
    {
      path: '/web/login',
      component: Login
    },
    {
      path: '*',
      component: NotFound
    }
  ];  
}
