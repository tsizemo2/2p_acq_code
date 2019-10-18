##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=home
ConfigurationName      :=Debug
WorkspacePath          :=C:/Users/wilson_lab/Desktop/Michael/actuatorMovementScripts
ProjectPath            :=C:/Users/wilson_lab/Desktop/Michael/actuatorMovementScripts
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=wilson_lab
Date                   :=06/11/2017
CodeLitePath           :="C:/Program Files/CodeLite"
LinkerName             :=C:/TDM-GCC-64/bin/g++.exe
SharedObjectLinkerName :=C:/TDM-GCC-64/bin/g++.exe -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.i
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
ObjectsFileList        :="home.txt"
PCHCompileFlags        :=
MakeDirCommand         :=makedir
RcCmpOptions           := 
RcCompilerName         :=C:/TDM-GCC-64/bin/windres.exe
LinkOptions            :=  -O0
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). $(IncludeSwitch)C:\Users\wilson_lab\Desktop\Michael\actuatorMovementScripts 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)Thorlabs.MotionControl.KCube.DCServo $(LibrarySwitch)Thorlabs.MotionControl.DeviceManager 
ArLibs                 :=  "Thorlabs.MotionControl.KCube.DCServo.dll" "Thorlabs.MotionControl.DeviceManager.dll" 
LibPath                := $(LibraryPathSwitch). $(LibraryPathSwitch). $(LibraryPathSwitch)Debug $(LibraryPathSwitch)C:\Users\wilson_lab\Desktop\Michael\actuatorMovementScripts 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := C:/TDM-GCC-64/bin/ar.exe rcu
CXX      := C:/TDM-GCC-64/bin/g++.exe
CC       := C:/TDM-GCC-64/bin/gcc.exe
CXXFLAGS :=  -g -Wall -std=c++11 $(Preprocessors)
CFLAGS   :=   $(Preprocessors)
ASFLAGS  := 
AS       := C:/TDM-GCC-64/bin/as.exe


##
## User defined environment variables
##
CodeLiteDir:=C:\Program Files\CodeLite
Objects0=$(IntermediateDirectory)/home.cpp$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild MakeIntermediateDirs
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

MakeIntermediateDirs:
	@$(MakeDirCommand) "./Debug"


$(IntermediateDirectory)/.d:
	@$(MakeDirCommand) "./Debug"

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/home.cpp$(ObjectSuffix): home.cpp $(IntermediateDirectory)/home.cpp$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "C:/Users/wilson_lab/Desktop/Michael/actuatorMovementScripts/home.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/home.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/home.cpp$(DependSuffix): home.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/home.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/home.cpp$(DependSuffix) -MM home.cpp

$(IntermediateDirectory)/home.cpp$(PreprocessSuffix): home.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/home.cpp$(PreprocessSuffix) home.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r ./Debug/


