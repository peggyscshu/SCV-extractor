//Prepare for batch
	//Import data
		dir1 = getDirectory("Choose folder with ML-recognized Bac DNA files ");
		list = getFileList(dir1);
	// Create folders for the tifs
		dir1parent = File.getParent(dir1);
		dir1name = File.getName(dir1);
		dir2 = dir1parent+File.separator+dir1name+"_Tiff_remove uninfected cells";
		if (File.exists(dir2)==false) {
			File.makeDirectory(dir2); 
		}
//Loop for multi files
		for (i=0; i<list.length; i++) {
			path=dir1+list[i];
			open(path);
			tifName = list[i];
			tifName = replace(tifName, ".tif", "");
			getDimensions(width, height, channels, slices, frames);
			rename("Raw");
			run("Set Measurements...", "area redirect=None decimal=2");
			//CCL
				run("Duplicate...", "duplicate");
				run("Z Project...", "projection=[Max Intensity]");
				/* Cellpose (abandoned due to speed) 
				run("Split Channels");
				imageCalculator("Add create", "C1-Raw","C2-Raw");
				selectImage("Result of C1-Raw");
				rename("C1AddC2");
				run("Median...", "radius=6");
				run("Enhance Contrast", "saturated=0.35");
				run("Apply LUT");
				run("Merge Channels...", "c1=C1AddC2 c3=C3-Raw create");
				run("Cellpose Advanced", "diameter=350 cellproba_threshold=-6.0 flow_threshold=0.4 anisotropy=1.0 diam_threshold=12.0 model=cyto2 nuclei_channel=2 cyto_channel=1 dimensionmode=2D stitch_threshold=-1.0 omni=false cluster=false additional_flags=");
				selectImage("Composite-cellpose");
				run("Label image to ROIs", "rm=[RoiManager[size=26, visible=true]]");
				*/
				setTool("freehand");
				waitForUser("Use the ROI tool to roughly select cells and use Ctrl+T to add the ROI in the list. After complete the selection, press OK.");
				newImage("CCL mask", "8-bit black", width, height, 1);
				c=roiManager("count");
				for (j = 0; j < c; j++) {
					selectWindow("CCL mask");
					roiManager("Select", j);
					run("Add...", "value=1");
				}
				roiManager("Deselect");
				imageCalculator("Multiply create stack", "Raw","CCL mask");
			//Clear
				selectWindow("Raw");
				close();
				selectWindow("Raw-1");
				close();
				selectWindow("MAX_Raw-1");
				close();
				selectWindow("CCL mask");
				close();
				roiManager("delete");
			//Save image
				selectWindow("Result of Raw");
				saveAs("TIFF", dir2+File.separator+tifName+"_remove uninfected cells");
				run("Close All");	
		}

