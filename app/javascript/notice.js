if(document.URL.match(/works/)){
function MessageTimer(){
  let myTime = new Date();
  let myHours = myTime.getHours();
  let myMinutes = myTime.getMinutes();
  let mySeconds = myTime.getSeconds();

  let strTime = myHours+"時"+myMinutes+"分"+mySeconds+"秒";
  let d_time = document.getElementById("time");
  d_time.innerHTML = strTime

  let ontime = myHours;

  let myMessage = document.getElementById("Message");

  let ListMessage = new Array(
    { time:"9" ,message:"出勤時間です"},
    { time:"12" ,message:"12時から13時はお昼休みです。60分間休憩しましょう。休憩中の賃金は発生しません。"},
    { time:"18" ,
    message:"勤務時間終了です。残業を希望する方は上司に連絡してください。"}
  );

  for(var i=0; i < ListMessage.length; i++){
    if( ontime == ListMessage[i]["time"] ){
      myMessage.innerHTML = ListMessage[i]["message"];
      setTimeout(function(){myMessage.innerHTML="";}, 60 * 60 * 1000);
    };
  };
  return 0;
}
setInterval(MessageTimer, 1000);
};