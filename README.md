# Get-ServiceAccountReport
# #DESCRIPTION
This function retrieved service accounts logged in a pool of computer passed as argument. 
It uses WMI requests.
#Warning : computers need to be on while they are being searched.

```PowerShell
import-module serviceAccountFinderModule.ps1
```

# #PARAMETER 
        -dn : specify a string with the scope of the search (specify an OU or a specific computer)
        - input_csv : take as input a csv list of computer names to look up
        
# #EXAMPLE
Find service accounts running on your domain controllers :
```PowerShell
Get-serviceAccountreport -dn 'OU=Domain Controllers,DC=domain,DC=local'
```
Find service accounts running on a specific set of computers joined in the domain :
    1. list thoses domain computers in a CSV file (see exemple in the repo named input.csv -> the computer names must be listed)
    2. 
```PowerShell
Get-serviceAccountreport -input_csv "./input.csv"'
```
# #RESULTS
A gridview will pop up with the results
A CSV file is automatically registered into the local folder

# #Contributors
  - Clement LAVOILLOTTE
  - Benoit ESTRADE
    
