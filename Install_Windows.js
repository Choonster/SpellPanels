// The path to WoW
var wowPath = "C:\\Users\\Public\\Games\\World of Warcraft"

// Where to save the downloaded ZIP. The ZIP will be extracted to a folder of the same name (minus the extension) before being copied to your AddOns folder.
var zipPath = "C:\\Users\\Bob\\Downloads\\SpellPanels_latest.zip"

// -------------
// END OF CONFIG
// -------------

var zipURL = "http://github.com/Choonster/SpellPanels/archive/master.zip"
var unzipPath = zipPath.match(/^(.+)\.zip$/)[1]

var addonPath = wowPath + "\\Interface\\AddOns\\!SpellPanels"

var req = new ActiveXObject("MSXML2.ServerXMLHTTP.3.0") // Download the ZIP
req.open("GET", zipURL, false)
req.send()

var fso = new ActiveXObject("Scripting.FileSystemObject")
var shell = new ActiveXObject("Shell.Application")

if (req.status == 200){
    // Write the ZIP to a file
	// http://stackoverflow.com/questions/4164400
	
	// Create a stream object to write downloaded data to
    var stream = new ActiveXObject("ADODB.Stream")
    stream.Open()
    stream.Type = 1 // adTypeBinary

    stream.Write(req.responseBody)
    stream.Position = 0

    // Create an empty file on disk
    
    // Make sure we don't have any name collision...
    if( fso.FileExists(zipPath) ) fso.DeleteFile(zipPath)
    
    // Write the stream data to file
    stream.SaveToFile(zipPath)
    stream.Close()
	
	// Unzip the file into a temporary folder
	// http://stackoverflow.com/questions/911053
	if (fso.FolderExists(unzipPath)) fso.DeleteFolder(unzipPath)
	fso.CreateFolder(unzipPath)
	
	var zipItems = shell.Namespace(zipPath).Items()
	shell.Namespace(unzipPath).CopyHere(zipItems)
	
	// Copy the files to WoW's AddOns folder
	
	if (fso.FolderExists(addonPath)) fso.DeleteFolder(addonPath)
	fso.CreateFolder(addonPath)
	
	var files = shell.Namespace(unzipPath + "\\SpellPanels-master").Items()
	shell.Namespace(addonPath).CopyHere(files)
}
else{
	throw new Error("Failed! " + req.status)
}