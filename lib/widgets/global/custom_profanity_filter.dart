const String rPrefix = r'[개갸씹좆]';
const String rSib = r'[씹]+';
const String rSibal = r'[시씨씹씌슈쓔쉬쉽쒸쓉]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[바발벌빠빡빨뻘파팔펄창]';
const String rByeonshin = r'[병븅빙볍븁빕뼝쁑삥뱡]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[신싄시씐쉰쒼슨]';
const String rSaeggi = r'(새끼|색히|샛기|색갸|샛갸|색햐|색기)+';
const String rJot = r'[좆]+';
const String rJotbap = r'[조좋좆좃쪼쫗쫒쫏줘줳줮줫쭤쭿쭺쭷찌자잫잦잣쥬즇쥿즂쥰좌좐좢좟좧]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)([바밥밮빠빱빺바밯빻창]+|(같은|가튼|그튼|같네|같다|가따|가타|가테|가태)+)';
const String rJonna = r'[조좆좃줘줳줮줫쭤쭿쭺쭷잫잦잣쥬즇쥿즂준쥰존죤좌좐좢좟좧]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[나니내네]';
const String rAmAb = r'[앰앱엠엡]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[업없뒤창]';
const String rAmi = r'[어애에]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[미]';
const String rAbi = r'[아애에]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[비]';
const String rSex = r'[섹섻색샋]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[스]';
const String rJazi = r'[자쥬]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[지]';
const String rBozi = r'[보뷰]([a-zA-Z0-9ㄱ-ㅎ가-힣]*)[지]';
const String rOthers = r'(코드 ㅈ같이 짜놨네 씨발럼 ㅋㅋ|진짜 이 씨발새끼 코드를 좀 깔끔하게 짜지 개좆같이 지저분하게 싸질러놔가지고 뭐 건드리기도 좆같고 개병신같은새끼가 진짜 이 씨발럼|)';
const String rSuffix = r'(같은|가튼|그튼|같네|같다|가따|가타|가테|가태|놈|넘|럼|람|년|련)';

final RegExp customProfanityFilter = RegExp('$rPrefix*($rSib|$rSaeggi|$rJot|$rSibal|$rByeonshin|$rJotbap|$rJonna|$rAmAb|$rAmi|$rAbi|$rSex|$rJazi|$rBozi$rOthers)+$rSuffix*');