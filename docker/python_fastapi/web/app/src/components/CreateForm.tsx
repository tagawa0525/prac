import React from "react";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import SendIcon from '@material-ui/icons/Send';
import Grid from "@material-ui/core/Grid";
import Box from "@material-ui/core/Box";
import User from './User';

function CreateForm(props: {
  user: User;
  onChange: (
    itemName: keyof User,
    e: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ) => void;
  onSubmit: React.MouseEventHandler<HTMLButtonElement> | undefined;
}) {
  return (
    <form>
      <Grid container>
        <Grid item xs={12}>
          <TextField
            label="name"
            id="name"
            value={props.user["username"]}
            onChange={(e) => props.onChange("username", e)}
          />
        </Grid>
        <Grid item xs={2} />
        <Grid item xs={8}>
          <TextField
            label="email"
            id="email"
            value={props.user["email"]}
            onChange={(e) => props.onChange("email", e)}
          />
        </Grid>
        <Grid item xs={2} />
        <Grid item xs={12}>
          <TextField
            label="password"
            id="password"
            value={props.user["password"]}
            onChange={(e) => props.onChange("password", e)}
          />
        </Grid>
        <Grid item xs={2} />
        <Grid item xs={12}>
          <Box mt={5}>
            <Button
              variant="contained"
              color="primary"
              startIcon={<SendIcon />}
              onClick={props.onSubmit}
            >
              CREATE
            </Button>
          </Box>
        </Grid>
      </Grid>
    </form>
  )
}

export default CreateForm;
