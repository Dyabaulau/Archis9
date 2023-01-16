import './App.css';
import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";

import SendUserForm from './components/SendUserForm';
import GetUsers from './components/GetUsers';

function App() {
  return (

    <div>
      <nav className='nav_bar'>
        <a className='nav_link' href='/'>New User</a>
        <a className='nav_link' href='/users'>All Users</a>
      </nav>

      <Router>
        <Routes>
          <Route path='/' element={<SendUserForm />}/>
          <Route path='/users' element={<GetUsers />}/>
        </Routes>
      </Router>
    </div>
  );
}

export default App;
