const express = require('express')
const app = express()
const port = 8080

const MY_VAR = process.env.MY_VAR || 'default'

app.get('/', (req, res) => {
  res.send('This is a test NodeJS V1 application. MY_VAR is ' + MY_VAR + '.')
})

app.listen(port, '0.0.0.0', () => {
  console.log(`Example app listening on port ${port}`)
})