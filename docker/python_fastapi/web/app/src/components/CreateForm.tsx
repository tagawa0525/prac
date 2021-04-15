import React from "react";
import { Grid, TextField } from "@material-ui/core";
import User from './User';

function CreateForm(props: {
  user: User;
  onChange: (
    itemName: keyof User,
    e: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ) => void;
}) {
  return (
    <form>
      <Grid container>
        <Grid item xs={12}>
          <TextField
            label="name"
            value={props.user["username"]}
            onChange={(e) => props.onChange("username", e)}
          />
        </Grid>

        <Grid item xs={12}>
          <TextField
            label="email"
            value={props.user["email"]}
            onChange={(e) => props.onChange("email", e)}
          />
        </Grid>

        <Grid item xs={12}>
          <TextField
            label="password"
            value={props.user["password"]}
            onChange={(e) => props.onChange("password", e)}
          />
        </Grid>

      </Grid>
    </form>
  )
}

export default CreateForm;
