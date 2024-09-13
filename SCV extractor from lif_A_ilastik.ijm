macro 'SCV extractor lif files_A' {
	ts=getTime();
	//Import data
		run("Bio-Formats Macro Extensions");
		dir1 = getDirectory("Choose folder with lif files ");
		list = getFileList(dir1);
		//Array.print(list);
//setBatchMode(true);
	// Create folders for the tifs
		dir1parent = File.getParent(dir1);
		dir1name = File.getName(dir1);
		dir2 = dir1parent+File.separator+dir1name+"--Tiff_DAPI";
		dir3 = dir1parent+File.separator+dir1name+"--Tiff_Raw";
		dir4 = dir1parent+File.separator+dir1name+"--Tiff_BacDNA";
		if (File.exists(dir2)==false) {
			File.makeDirectory(dir2); 
		}
		if (File.exists(dir3)==false) {
			File.makeDirectory(dir3); 
		}
		if (File.exists(dir4)==false) {
			File.makeDirectory(dir4); 
		}
	//Loop for multi lif files
		for (i=0; i<list.length; i++) {
			//Progress bar
				showProgress(i+1, list.length);
				print("processing ... "+i+1+"/"+list.length+"\n         "+list[i]);
			//Open dataset
				path=dir1+list[i];
			//How many series in this lif file?
				Ext.setId(path);
				Ext.getSeriesCount(seriesCount);
			//Open one of the series
			 	for (j=1; j<=seriesCount; j++) {
					run("Bio-Formats", "open=path autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_"+j);
					//Retrieve name of the series from metadata
						name=File.nameWithoutExtension;
					   	text=getMetadata("Info");
						n1=indexOf(text,"Image name = ")+13;
						n2=indexOf(text,"Location = ");
						seriesname=substring(text, n1, n2-1);
					//Save lif to tif
						saveAs("TIFF", dir3+File.separator+name+"_"+seriesname+"_Raw");
					//Save DAPI channel to tif
						run("Duplicate...", "title=DAPI duplicate channels=3");//<---------Change channel nb here!! 
						selectWindow("DAPI");
						saveAs("TIFF", dir2+File.separator+name+"_"+seriesname+"_DAPI");
					//Close raw image
						selectWindow(name+"_"+seriesname+"_Raw.tif");
						close();
					//Run ilastik
						selectWindow(name+"_"+seriesname+"_DAPI.tif");
						run("Configure ilastik executable location", "executablefile=[C:\\Program Files\\ilastik-1.4.0-gpu\\ilastik.exe] numthreads=-1 maxrammb=4096");//<------------------------The absolute path of ilastik
						//run("Run Pixel Classification Prediction", "projectfilename=[E:\\PROJECTS_L\\ImagingCore\\User Data\\IOM\\SJC\\Expansion data\\20231105_ExM_wt and SSEFm_1_SP8\\Tool\\ExM_Salmonella DNA.ilp] inputimage=Demo_1W_DAPI.tif pixelclassificationtype=Segmentation");
						project = "E:\\PROJECTS_L\\ImagingCore\\User Data\\IOM\\SJC\\Expansion data\\20231105_ExM_wt and SSEFm_1_SP8\\Tool\\ExM_Salmonella DNA.ilp";//<---------The absolute path of the trained model!! 
						input = name+"_"+seriesname+"_DAPI.tif";
						type = "Segmentation";
						run("Run Pixel Classification Prediction", "projectfilename=[" + project + "] inputimage=[" + input + "] pixelclassificationtype=[" + type + "]");
						saveAs("TIFF", dir4+File.separator+name+"_"+seriesname+"_Bac DNA");
						rename("BacDNA");
					//Add back to the raw image
						open(dir3+File.separator+name+"_"+seriesname+"_Raw.tif");
						rename("Raw");
						run("Split Channels");
						run("Merge Channels...", "c1=C1-Raw c2=C2-Raw c3=C3-Raw c4=BacDNA");
						saveAs("TIFF", dir4+File.separator+name+"_"+seriesname+"_Bac DNA");
						run("Close All");
				}//series list
		}//lif file list
tend=getTime();
tdu=(tend-ts)/1000/60;
showMessage(" -- finished --" + tdu +" min");	
run("Close All");
//setBatchMode(false);
}//macro