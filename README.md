## NAME

CDQR — Cold Disk Quick Response tool by Alan Orlikoski

For latest release click [here](https://github.com/orlikoski/CDQR/releases/latest)
## Videos and Media
*  [OSDFCON 2017](http://www.osdfcon.org/presentations/2017/Asif-Matadar_Rapid-Incident-Response.pdf) Slides: Walk-through different techniques that are required to provide forensics results for Windows and *nix environments (Including CyLR and CDQR)


## What is CDQR?
The CDQR tool uses Plaso to parse disk images with specific parsers and create easy to analyze custom reports. The parsers were chosen based triaging best practices and the custom reports group like items together to make analysis easier. The design came from the Live Response Model of investigating the important artifacts first. This is meant to be a starting point for investigations, not the complete investigation.

In addition to processing entire forensic images it also parses extracted forensic artifact(s) as an individual file or collection of files inside of a folder structure (or inside a .zip file).

It creates up to 16 Reports (.csv files) based on triaging best practices and the parsing option selected
*  16 Reports for DATT:  
      ```
      Appcompat, Login, Event Logs, File System, MFT, UsnJrnl, Internet History, Prefetch, Registry, Scheduled Tasks, Persistence, System Information, AntiVirus, Firewall, Mac, and Linux
      ```
*  14 Reports for Win:  
      ```
      Appcompat, Login, Event Logs, File System, MFT, UsnJrnl, Internet History, Prefetch, Registry, Scheduled Tasks, Persistence, System Information, AntiVirus, Firewall
      ```
*   8 Reports for Mac and Lin:  
      ```
      Login, File System, Internet History, System Information, AntiVirus, Firewall, Mac, and Linux
      ```

## Important Notes
* Make sure account has permissions to create files and directories when running (when in doubt, run as administrator)
*  Ensure line endings are correct for the OS it is running on

## DESCRIPTION

This program uses [Plaso](https://github.com/log2timeline/plaso/wiki) and a streamlined list of its parsers to quickly analyze a forenisic image file (dd, E01, .vmdk, etc) or group of forensic artifacts.  The results are output in either ElasticSearch, JSON (line delimited), or the following report files in CSV format:
*  16 Reports for DATT:  
      ```
      Appcompat, Login, Event Logs, File System, MFT, UsnJrnl, Internet History, Prefetch, Registry, Scheduled Tasks, Persistence, System Information, AntiVirus, Firewall, Mac, and Linux
      ```
*  14 Reports for Win:  
      ```
      Appcompat, Login, Event Logs, File System, MFT, UsnJrnl, Internet History, Prefetch, Registry, Scheduled Tasks, Persistence, System Information, AntiVirus, Firewall
      ```
*   8 Reports for Mac and Lin:  
      ```
      Login, File System, Internet History, System Information, AntiVirus, Firewall, Mac, and Linux
      ```

## ARGUMENTS & OPTIONS
```
positional arguments:
  src_location          Source File location: Y:/Case/Tag009/sample.E01
  dst_location          Destination Folder location. If nothing is supplied
                        then the default is 'Results'

optional arguments:
  -h, --help            show this help message and exit
  -p PARSER, --parser PARSER
                        Choose parser to use. If nothing chosen then 'win' is
                        used. The parsing options are: win, mft_usnjrnl, lin, 
                        mac, datt
  --nohash              Do not hash all the files as part of the processing of
                        the image
  --mft                 Process the MFT file (disabled by default except for
                        DATT)
  --usnjrnl             Process the USNJRNL file (disabled by default except
                        for DATT)
  --max_cpu             Use the maximum number of cpu cores to process the
                        image
  --export              Creates zipped, line delimited json export file
  --artifact_filters ARTIFACT_FILTERS
                        Plaso passthrough: Names of forensic artifact
                        definitions, provided on the command command line
                        (comma separated). Forensic artifacts are stored in
                        .yaml files that are directly pulled from the artifact
                        definitions project. You can also specify a custom
                        artifacts yaml file (see
                        --custom_artifact_definitions). Artifact definitions
                        can be used to describe and quickly collect data of
                        interest, such as specific files or Windows Registry
                        keys.
  --artifact_filters_file ARTIFACT_FILTERS_FILE
                        Plaso passthrough: Names of forensic artifact
                        definitions, provided in a file with one artifact name
                        per line. Forensic artifacts are stored in .yaml files
                        that are directly pulled from the artifact definitions
                        project. You can also specify a custom artifacts yaml
                        file (see --custom_artifact_definitions). Artifact
                        definitions can be used to describe and quickly
                        collect data of interest, such as specific files or
                        Windows Registry keys.
  --artifact_definitions ARTIFACT_DEFINITIONS
                        Plaso passthrough: Path to a directory containing
                        artifact definitions, which are .yaml files. Artifact
                        definitions can be used to describe and quickly
                        collect data of interest, such as specific files or
                        Windows Registry keys.
  --custom_artifact_definitions CUSTOM_ARTIFACT_DEFINITIONS
                        Plaso passthrough: Path to a file containing custom
                        artifact definitions, which are .yaml files. Artifact
                        definitions can be used to describe and quickly
                        collect data of interest, such as specific files or
                        Windows Registry keys.
  --file_filter FILE_FILTER, -f FILE_FILTER
                        Plaso passthrough: List of files to include for
                        targeted collection of files to parse, one line per
                        file path, setup is /path|file - where each element
                        can contain either a variable set in the preprocessing
                        stage or a regular expression.
  --es_kb ES_KB         Outputs Kibana format to elasticsearch database.
                        Requires index name. Example: '--es_kb my_index'
  --es_kb_server ES_KB_SERVER
                        Kibana Format Only: Exports to remote (default is
                        127.0.0.1) elasticsearch database. Requires Server
                        name or IP address Example: '--es_kb_server
                        myserver.elk.go' or '--es_kb_server 192.168.1.10'
  --es_kb_port ES_KB_PORT
                        Kibana Format Only: Port (default is 9200) for remote
                        elasticsearch database. Requires port number Example:
                        '--es_kb_port 9200 '
  --es_kb_user ES_KB_USER
                        Kibana Format Only: Username (default is none) for
                        remote elasticsearch database. Requires port number
                        Example: '--es_kb_user skadi '
  --es_ts ES_TS         Outputs TimeSketch format to elasticsearch database.
                        Requires index/timesketch name. Example: '--es_ts
                        my_name'
  --plaso_db            Process an existing Plaso DB file. Example:
                        artifacts.plaso
  -z                    Indicates the input file is a zip file and needs to be
                        decompressed
  --no_dependencies_check
                        Re-enables the log2timeline the dependencies check. It
                        is skipped by default
  --process_archives    Extract and inspect contents of archives found inside
                        of artifacts or disk images
  -v, --version         show program's version number and exit
  -y                    Accepts all defaults on prompted questions in the
                        program.
```

## PARSER LIST

There are four available parsers for CDQR: `win` , `mft_usnjrnl` , `mac` , `lin` , and `datt`  and here the Plaso parsers they represent:
* **win**
  ```
  bencode,czip,ccleaner,esedb,filestat,lnk,mcafee_protection,olecf,pe,prefetch,recycle_bin,recycle_bin_info2,sccm,sophos_av,sqlite,symantec_scanlog,winevt,winevtx,webhist,winfirewall,winjob,windows_typed_urls,winreg
  ```
* **mft_usnjrnl**
  ```
  mft,usnjrnl
  ```
* **mac**
  ```
  asl_log,bash_history,bash,bencode,bsm_log,ccleaner,cups_ipp,czipplist,filestat,fseventsd,mcafee_protection,mac_appfirewall_log,mac_keychain,mac_securityd,macwifi,mcafee_protection,olecf,sophos_av,sqlite,symantec_scanlog,syslog,utmpx,webhist,zsh_extended_history

  ```
* **lin**
  ```
  bash,bash_history,bencode,czip,dockerjson,dpkg,filestat,mcafee_protection,olecf,pls_recall,popularity_contest,selinux,sophos_av,sqlite,symantec_scanlog,syslog,systemd_journal,utmp,webhist,xchatlog,xchatscrollback,zsh_extended_history

  ```
* **datt**
  ```
  amcache,android_app_usage,apache_access,asl_log,bash_history,bash,bencode,binary_cookies,bsm_log,chrome_cache,chrome_preferences,cups_ipp,custom_destinations,czip,dockerjson,dpkg,esedb,filestat,firefox_cache,firefox_cache2,fsevents,gdrive_synclog,hachoir,java_idx,lnk,mac_appfirewall_log,mac_keychain,mac_securityd,mactime,macwifi,mcafee_protection,mft,msiecf,olecf,opera_global,opera_typed_history,pe,plist,pls_recall,popularity_contest,prefetch,recycle_bin_info2,recycle_bin,rplog,santa,sccm,selinux,skydrive_log_old,skydrive_log,sophos_av,sqlite,symantec_scanlog,syslog,systemd_journal,trendmicro_url,trendmicro_vd,usnjrnl,utmp,utmpx,winevt,winevtx,winfirewall,winiis,winjob,winreg,xchatlog,xchatscrollback,zsh_extended_history
  ```
## DEPENDENCIES

1. 64-bit Windows, Linux, or Mac Operating System (OS)
2. The appropriate version of Plaso for the OS https://github.com/log2timeline/plaso/releases
3. [Python v3.x](https://www.python.org/downloads/) (if using cdqr.py source code)

## EXAMPLES

```
cdqr.py c:\mydiskimage.vmdk myresults
```
```
cdqr.exe -p win c:\images\badlaptop.e01
```
```
cdqr.exe -p datt --max_cpu C:\artifacts\tag009
```
```
cdqr.exe -p datt --max_cpu C:\artifacts\tag009\$MFT --export
```
```
cdqr.exe -z --max_cpu C:\artifacts\tag009\artifacts.zip
```
```
cdqr.exe -z --max_cpu C:\artifacts\tag009\artifacts.zip --es myindexname
```


## AUTHOR

Alan Orlikoski
* [GitHub](https://github.com/orlikoski)
* [Twitter](https://twitter.com/AlanOrlikoski)
