#Hey! If you want to change some parameters you are at the right place!
#You can ONLY change the values of the variables, not their names!!
#You also MUST change values by values of the same type: eg you can change "$IEdepth = 4" to "$IEdepth = 3" but NOT to "$IEdepth = 'auto' "

##################################################################################################################
#######################################################[GLOBAL CONFIG]#####################################################		           
				 #parameters for the main programm

#what to simulate ($false / $true)

$global_IE = $true		        #whether to simulate an user internet explorer activity
$global_MapShare = $false		#whether to attempt to map shared drives to 'K' !Warning! This can expose the machine to attacks

$global_type = $false           #whether to simulate keystrokes (copying the contents of file .\Misc\to_write.txt) 
                                #!Beware of this feature! If another script is running, or even just an user clicking somewhere, this could shut down the virtual machine or launch programms via keystrokes

$global_unactivity = 1		   	#time (seconds) the user will do nothing, before repeating a range of different activities. Value between 1 and 3600
$global_actiontimeout = 10	    #max time in seconds by activity, if something takes longer it will be terminated. Value between 1 and 3600
$global_duration = 0			#show long run the simulation? Specify the duration in minutes from 1 to 1000000000, with 0 indicating infinite. Remember it has to complete a round of activities before stopping so if some activity takes long it will not stop exactly after the specified time.

$global_standalone = $true		#whether to operate only localy ($true) or server-mode ($false)
$global_schedule = $false       #whether to follow the given schedule
$global_email = $false          #whether to send an email with the latest log to the specified address at the end of the simulation (if it's ending). Your server must support anonymous sending (rarely the case...).


#######################################################[Server Mode]#####################################################		           
#parameters for the server mode function (if active)
$global_autodetect = $true 		# whether to auto-detect PC running on the same network. Beware! : it relies on microsoft 'net -view' command and windows discovery of network PC. It is unreliable, even more if the instructions given in documentation are not followed

$global_listPCs = "PC1"		    #Has no effect if autodetect is $true. But can be useful if one already know the what the network is made of (read: the names of PCs in the network) IF you already know the names of the PCs in the network and are sure they are connected etc... PLEASE set autodetect to false and use this list, it is much more reliable


#######################################################[IE]#####################################################		           
#parameters for the internet explorer usage simulation
$IE_quitafter = 2               #quitafter : How much time to wait before closing a webpage. default 3 (seconds), value between 1 and 10000000000
$IE_depth = 2                   #depth: IE simulation browse a website from the list, click a link found on the page etc.... until  it reach depth. value between 1 and 1000000 . Note: the bigger the depth, the higher the chances of browsing being reported as failure (more chances to click a invalid link or timeout)


#list of urls to try to visit for IE simulation


# main URL where the urls.txt file is located. Change it to the good one.
# IMPORTANT:  All lines of urls.txt file must begin with "http". 
# "$IE_URis" will be use as a fallback if it failed, so be sure variable IE_URIs is accurate.
# [CHANGEME]
$IE_URIs_link = "http://127.0.0.1/urls.txt"
$IE_URIs_file = "urls.txt"
write-host "[+] Getting URLs at $IE_URIs_link"


# default fallback urls 
# [CHANGEME]
$IE_URIs = @(
"https://www.google.com",
"http://www.github.com",
"http://www.youtube.com",
"http://error.lan"
    )

$IE_URIs| set-content -path $IE_URIs_file -force

try {
$code = iwr -uri $IE_URIs_link -usebasicparsing -useragent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0" -TimeoutSec 10| Select-Object StatusCode

# check if 200 OK
if ($code.StatusCode -eq "200") {
	write-host "[+] Got a file, downloading it."
    $resp = iwr -uri $IE_URIs_link -UseBasicParsing -useragent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0" -TimeoutSec 10

}

    $startsWithHttp = $resp.content | ForEach-Object { $_ -match '^http' }
    # check if every line begin with http, to prevent a 200 that returns default page output
    if ($startsWithHttp -contains $true) {
        $resp.content | Out-File -FilePath $IE_URIs_file -force
        #write-host "[-] Error while contacting server..."
        # check if $IE_URIs_file is empty ...
        if ((Get-Content -Path $IE_URIs_file -Raw) -eq "") {
            # If empty, go default
	        write-host "[+] File is empty :( Using default :" 
            write-host "######"
            write-host $IE_URIs
            write-host "######"
        }
        #  if not empty, use the file
        else {
        $IE_URIs = Get-Content -Path $IE_URIs_file -Raw
        $IE_URIs = $IE_URIs | ForEach-Object { $_.Trim() }
        write-host "[+] File seems to be OK. Using values : "
        write-host "######"
        write-host "$IE_URIs"
        write-host "######"
        }
    }
    else {write-host "[-] Error: One or more line are not starting with 'http' !"}


}
catch{
    Write-Host "An error occurred: $($_.Exception.Message)"
    }
finally{
    

    write-host "[+] Error. Using default."
    $IE_URIs = Get-Content -Path $IE_URIs_file -Raw
    write-host "######"
    write-host "$IE_URIs"
    write-host "######"
}


##################################################################################################################
##################################################################################################################


##################################################################################################################
##################################################[MapShare]#########################################################
#parameters for the shared drive maping (LLMNR traffic generator)


#list of (fakes?) sharepoints the user try to connect to and map their K drive to.
$MapShare_locations =	"\\dc1.domain.corp\sysvol", 
			            "\\file.domain.corp\share",
						"\\printer.domain.corp\print"

##################################################[MapShare]#########################################################
#parameters for the shared drive maping (LLMNR traffic generator)

#the text to be typed can be found (and modified) in Misc\to_write.txt
$Type_speed = 60                                #time taken to write one character, in milliseconds (lower value means faster typing) Value between 1 and 10000000 . Anything too big is unadvised as for long text it would take a while and get timeout-ed

##################################################[Mail logs]#########################################################
#how and to whom send logs. !this could not be tested. IF YOU ARE UNSURE DO NOT MODIFY ANTYHING
$global:PSEmailServer = "smtp.domain.com"  	  	#if you wish to get logs via e-mail and activated the global_email option, you must provide a valid SMTP server. The server also must support anonymous sender (which is rarely the case..)
$global:email_address = "name@domain.com"   	#The email address to who send the logs. If global_email is activated, you have to provide a valid email.

 