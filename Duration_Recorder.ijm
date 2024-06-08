//Ver1.1---------------------------------------------------------------------

//---------------------------------------------------------------------------
function time_record_one_sample(){
	//サンプル#を取得して記録
	Dialog.create("Sample number");
	Dialog.addNumber("Enter the sample number", 1);
	Dialog.show;
	sample_number = Dialog.getNumber();
	row = nResults; //現在のresultの行数
	setResult("#", row, sample_number);
	
	fps = Stack.getFrameRate();
	
	time_former = 0;
	flag_file = 0;
	for(i = 0; i < column.length; i++){
		flag_key = 1;
		while(flag_key){
			if(isKeyDown("space")){
				Stack.getPosition(channel, slice, frame);
				time = slice / fps;
				//whileループ中に同一のspaceクリックが別データとして認識されるのを防ぐ
				if(time_former != time){
					setResult(column[i], row, time);
					updateResults();
					flag_key = 0;	
				}
				time_former = time;
			}
			wait(100);
			//shiftキーでこのファイルの記録を終了する
			if(isKeyDown("shift")){
				flag_file = 1;
				break;
			}
		}
		if(flag_file){
			break;
		}
	}
}
//---------------------------------------------------------------------------

//3回目までを記録する
column = newArray("1-start", "1-end", "2-start", "2-end", "3-start", "3-end");

//MAIN-----------------------------------------------------------------------

//作業ディレクトリの選択
showMessage("Select Open Folder");
dir = getDirectory("Choose Directory");
list = getFileList(dir); //作業ディレクトリの中にあるファイルのリスト

for(j=0; j<list.length; ++j){
	name = list[j];
	extension = indexOf(name, "."); //拡張子(.を含む)
	namewithoutextension = substring(name, 0, extension); //元データは"namewithoutextension + extension"
	path = dir+name;
	
	open(path);
	selectImage(name);
	run("Enhance Contrast", "saturated=0.35");
			
	time_record_one_sample();
	close();
}
saveAs("Results");
//---------------------------------------------------------------------------
