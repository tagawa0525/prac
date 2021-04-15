import React from 'react';
import './App.css';
import { DataGrid, GridColDef, GridRowSelectedParams } from '@material-ui/data-grid';
import { Button } from '@material-ui/core';
import { Create, Update, Delete } from '@material-ui/icons';
import CreateForm from './components/CreateForm';
import User from './components/User';


class App extends React.Component<{}, {
  users: User[],
  userInput: User,
  userSelectId: number
}> {
  constructor(props: {} | Readonly<{}>) {
    super(props);
    this.state = {
      userInput: new User(),
      userSelectId: 0,
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
      { field: 'id', headerName: "id", width: 75 },
      { field: 'username', headerName: "name", width: 150 },
      { field: 'email', headerName: "mail", width: 200 },
    ]

    return (
      <div style={{ height: 1110, width: '100%' }}>
        <DataGrid
          rows={this.state.users}
          columns={columns}
          pageSize={40}
          //autoHeight={true}
          rowHeight={25}
          hideFooterSelectedRowCount={true}
          onRowSelected={(newSelection) => {
            this.setSelectionModel(newSelection);
          }}
        />
      </div>
    );
  }

  setSelectionModel(newSelection: GridRowSelectedParams) {
    this.setState({
      userSelectId: +newSelection.data.id
    })
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

  handleUserUpdate(id: number, user: User, e: { preventDefault: () => void; }) {
    e.preventDefault();
    user.id = id
    const userJson = JSON.stringify(user);
    this.axios.post('/users/update', userJson)
      .then((res: { [x: string]: User; }) => {
        const users = this.state.users.slice();
        const index = users.findIndex(post => post["id"] === user.id);
        users.splice(index, 1, res["data"]);

        this.setState({
          users: users
        });
      })
      .catch((data: any) => {
        console.log(data);
      });
  }

  handleUserDelete(id: number, e: { preventDefault: () => void; }) {
    e.preventDefault();
    const user = this.state.users.filter(function (element, index, array) {
      return (element.id === id)
    })[0];
    const userJson = JSON.stringify(user);
    this.axios.post("/users/delete/", userJson)
      .then((res: { [x: string]: { [x: string]: any; }; }) => {
        const targetIndex = this.state.users.findIndex(user => {
          return user.id === res["data"]["id"]
        });
        const users = this.state.users.slice();
        users.splice(targetIndex, 1);

        this.setState({
          users: users
        });
      })
      .catch((data: any) => {
        console.log(data);
      });
  }

  render() {
    return (
      <div className="App">
        {this.getUsers()}
        <br></br>

        <CreateForm
          user={this.state.userInput}
          onChange={this.handleInputChange}
        />
        <br></br>

        <Button
          variant="contained"
          color="primary"
          startIcon={<Create />}
          onClick={this.handleUserSubmit}
        > CREATE </Button>

        <Button
          variant="contained"
          color="secondary"
          startIcon={<Delete />}
          onClick={(e) => this.handleUserDelete(this.state.userSelectId, e)}
        > DELETE </Button>

        <Button
          variant="contained"
          color="primary"
          startIcon={<Update />}
          onClick={(e) => this.handleUserUpdate(this.state.userSelectId, this.state.userInput, e)}
        > UPDATE </Button>
      </div>
    );
  }
}

export default App;