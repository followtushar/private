import requests
import json
import time
import csv

def getdata():
    #######################################################################################################
    ##################################### Edit values here ################################################

    header = {
        "Ocp-Apim-Subscription-Key": "314de884588f46079483e99f9d653fba" 
        }
    environment ='uat' #ex : uat , prod , dev 
    date ='2021-11-16' #ex : YYYY-MM-DD 
    operator= 'buse'   #ex : dbus , buse
    #outputLocation= 'C:\Users\tkumar\OneDrive - Codec\Documents\Work\NTA'
    url_base = "https://apiuat.nationaltransport.ie/to/"+operator+"/"+environment+"?filter=Passenger_Journey_Date&operation=eq&param_value='"+date+"'"
    
    ###########################################Don't Mdify Below this line ##############################################################

    file_name= 'All_records'+ date +'.json'       # Create filemane All_records_2021-10-28.json

    #####################################################################################################################################

    s = requests.Session()
    nexlink = 1
    records = 0
    jsondata= []
    while nexlink > 0 :
        # Create String with Skip value
        print(records)
        url_get = url_base+"&$skip="+str(records)
        
        #Call the API to Get the value 
        resp = s.get(url_get, headers=header, verify=False)
        data = resp.json()
        if 'statusCode' in data:
            if data['statusCode'] == 429:
                    print('API Threshold reached starting again in 60s')
                    time.sleep(60)
                    continue
        if '@odata.nextLink' not in data:
            if 'value' in data:
                jsondata +=data["value"]
            nexlink=0
            print('*********************************End of Script************************************************')
            print('No next Page found!')
        else : 
            print('Collecting Data from Next pages :')
            print('--------------------------------------------------------------------------------------------------')
            
            if records==0: 
                    jsondata = data["value"]
            else:
                    jsondata +=data["value"]
            print('--------------------------------------------------------------------------------------------------')
        #Increase the value for next run
        records += 50
    with open(file_name, 'w+', encoding='utf-8') as f:
        json.dump(jsondata, f, ensure_ascii=False, indent=4)
    with open(file_name) as json_file:
            jsondata = json.load(json_file)
    outputfile= 'All_records'+ date +'.csv'
    data_file = open(outputfile, 'w+', newline='')
    csv_writer = csv.writer(data_file)
    count = 0
    for data in jsondata:
        if count == 0:
            header = data.keys()
            csv_writer.writerow(header)
            count += 1
    csv_writer.writerow(data.values())
    data_file.close()
    
getdata()

