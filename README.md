# SCV-extractor                  ![image](https://github.com/user-attachments/assets/9513fb3b-8b75-4b32-8bbb-088f24a33dd7)

https://zenodo.org/records/13756849


Extract SCV structures from the fluorescence images with Lamp1 and DAPI.

![image](https://github.com/user-attachments/assets/c2203ca0-be15-4e6a-9102-6cf7c854aad3)


## Biological question to be resolved
Intracellular Salmonella are confined in membrane-bound compartments termed Salmonella-containing vacuoles (SCVs) which acquire late endosomal markers. By the coexistence of the lysosomal membrane proteins such as LAMP1 and the bacterial DNA, SCV can be recognized easily by human eyes. However, these staining patterns are mixed with cellular lysosomes without bacteria and the nucleus of the parasitic cell respectively (Fig.1). By simply binarize the DNA staining or LAMP1 staining channel, SCVs are either under- or over-estimated (Fig. 2). Here I established a workflow to extract SCVs by the assistance of the machine learning tool ilastik for further quantification requests.

## Figures
![image](https://github.com/user-attachments/assets/72c6f1c3-35d9-4200-a1c4-4ae29b30a4c9)

![image](https://github.com/user-attachments/assets/8257be23-ea34-4341-95db-3d91a8ce3c9c)

## Tutorial for the usage
[Youtube link](https://www.youtube.com/watch?v=7WKl4Sz-yvk&list=PL62vGjlvu5bAKZhsco0hMtTJtA5D7GM5e&index=3)

## Instruction for the usage
Three channels images were contained in the original dataset from an expansion microscopy processed cell. 
Channel 1  Mitochondrial citrate carrier (CIC)
Channel 2  Lamp1
Channel 3  DAPI
The workflow is composed by 3 parts. 
1. Extract bacterial DNA and add back as an additional channel to the raw dataset from Leica lif file by a Fiji script (SCV extractor from lif_A_ilastik.ijm). A trained ilastik project for 3D images is also included in this GitHub (ExM_Salmonella DNA.ilp). Please be aware that the pretrained project may not fit diverse infection conditions. It is required to train your own model by your own dataset if it is needed. 
2. Semi-automatically remove non-infected cells by another Fiji script (SCV extractor from lif_B_remove uninfected cells.ijm).
3. Generate Lamp1, SCV and CIC 3D surfaces with Imaris in the batch format. The parameters for batch processing is included (SCV extractor.icsx).

## Requirements
1. Fiji
2. ilastik
3. ilastik Fiji plugin (Fiji\Help\Update\Update management\ ilastik)
4. a pretrained ilastik model
5. Imaris or any 3D analysis software ex. 3D Objects Counter in Fiji for further quantification.

## Installation
1.	Download and install Fiji from here. 
https://fiji.sc/
2.	Download and install ilastik here.
https://www.ilastik.org/
3.	Activate ilastik update in Fiji (Fiji\Help\Update\Update management\ ilastik) and set the configuration of ilastik to indicate the path where ilastik is installed (Fiji\Plugins\ilastik\Configure ilastik executable location).
4.	Try the provided model first. If the result is not as your expectation, please train a new one with your dataset with the pixel classification of ilastik. 

## Published with

## Acknowledgements
This work was supported by National Science and Technology Council NSTC 113-2320-B-002-076 to Shao-Chun Hsu.
 



