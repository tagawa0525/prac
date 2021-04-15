
interface User {
  username: string;
  email: string;
  password: string;
  is_active: boolean;
  is_superuser: boolean;
}

class User {
  constructor() {
    this.username = "new user";
    this.email = "sample@example.com";
    this.password = "p@ssw0rd";
    this.is_active = true;
    this.is_superuser = false;
  }
}

export default User;
