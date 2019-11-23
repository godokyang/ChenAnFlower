import Home from './Home';
import Manage from './Manage'

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
      path: '*',
      component: NotFound
    }
  ];  
}