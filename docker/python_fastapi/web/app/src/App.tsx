import React from 'react';
import './App.css';
import { DataGrid, GridColDef } from '@material-ui/data-grid';
import CreateForm from './components/CreateForm';
import User from './components/User';


class App extends React.Component<{}, {
  users: User[],
  userInput: User
}> {
  constructor(props: {} | Readonly<{}>) {
    super(props);
    this.state = {
      userInput: new User(),
      users: [],
    };
    this.handleInputChange = this.handleInputChange.bind(this);
    this.handleUserSubmit = this.handleUserSubmit.bind(this);
  }

  get axios() {
    const axiosBase = require('axios');
    return axiosBase.create({
      baseURL: "http://192.168.1.108:8000",
      // baseURL: "http://localhost:8000",
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      },
      responseType: 'json'
    });
  }

  componentDidMount() {
    this.axios.get('/users')
      .then((res: { data: any; }) => {
        this.setState({
          users: res.data
        });
      })
      .catch((data: any) => {
        console.log(data);
      })
  }

  getUsers() {
    const columns: GridColDef[] = [
      { field: 'id', headerName: "id", width: 50 },
      { field: 'username', headerName: "name", width: 150 },
      { field: 'email', headerName: "mail", width: 200 },
    ]

    return (
      <div style={{ height: 400, width: '100%' }}>
        <DataGrid rows={this.state.users} columns={columns} pageSize={5} checkboxSelection />
      </div>
    );
  }

  handleInputChange(
    itemName: keyof User,
    e: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ) {
    const newUser = Object.assign({}, this.state.userInput)
    switch (itemName) {
      case 'username':
        newUser.username = e.target.value;
        break;
      case 'email':
        newUser.email = e.target.value;
        break;
      case 'password':
        newUser.password = e.target.value;
        break;
    }

    this.setState({
      userInput: newUser
    });
  }

  handleUserSubmit(e: { preventDefault: () => void; }) {
    e.preventDefault();
    const userJson = JSON.stringify(this.state.userInput);

    this.axios.post("/users/create", userJson)
      .then((res: { [x: string]: any; }) => {
        const users = this.state.users.slice();
        users.push(res["data"]);
        this.setState({
          users: users,
          userInput: new User(),
        });
      })
      .catch((data: any) => {
        console.log(data)
      });
  }

  render() {
    return (
      <div className="App">
        {this.getUsers()}
        <CreateForm
          user={this.state.userInput}
          onChange={this.handleInputChange}
          onSubmit={this.handleUserSubmit}
        />
      </div>
    );
  }
}

export default App;