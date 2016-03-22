require("coffee-script/register");

require("./src/test.coffee");

process.on('uncaughtException',function(err){
  console.log("Caught exception: ", err);
});
