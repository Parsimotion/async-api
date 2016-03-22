require("coffee-script/register");

require("./src/server.coffee")();

process.on('uncaughtException',function(err){
  console.log("Caught exception: ", err);
});
