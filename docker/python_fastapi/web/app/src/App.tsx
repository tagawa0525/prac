import React from 'react';
import './App.css';
import { DataGrid, GridColDef } from '@material-ui/data-grid';

class App extends React.Component<{}, { users: any[] }> {
  constructor(props: {} | Readonly<{}>) {
    super(props);
    this.state = {
      users: []
    };
  }

  get axios() {
    const axiosBase = require('axios');
    return axiosBase.create({
      baseURL: "http://localhost:8000",
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      },
      responseType: 'json'
    });
  }

  componentDidMount() {
    this.axios.get('/users')
      .then((results: { data: any[]; }) => {
        console.log(results.data);
        this.setState({
          users: results.data
        });
      })
      .catch((data: any) => {
        console.log(data);
      })
  }

  getUsers() {
    const columns: GridColDef[] = [
      { field: 'id',       headerName: "id",   width:  50 },
      { field: 'username', headerName: "name", width: 150 },
      { field: 'email',    headerName: "mail", width: 200 },
    ]
    console.log(this.state)

    return (
      <div style={{ height: 400, width: '100%' }}>
        <DataGrid rows={this.state.users} columns={columns} pageSize={5} checkboxSelection />
      </div>
    );
  }


  render() {
    return (
      <div className="App">
        {this.getUsers()}
      </div>
    );
  }
}

export default App;
