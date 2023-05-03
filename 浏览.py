import os,time
url = str(os.environ.get('url'))
#print(url)
value = str(os.environ.get('value'))
cookie = {"name": "__Host-KAGGLEID", "value": value}

#from IPython.display import Image
from selenium import webdriver
from selenium.webdriver.common.by import By

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument("--window-size=1920,1080")
driver = webdriver.Chrome(options=chrome_options)
driver.get(url)
time.sleep(5)

driver.add_cookie(cookie)
time.sleep(5)
driver.get(url)
time.sleep(5)

def addcell():
    a_cell='//*[@id="site-content"]/div[2]/div/div[2]/div/div[1]/button[1]'
    elem_a = driver.find_element(by=By.XPATH, value=a_cell)
    elem_a.click()

def deletecell():
    d_cell='//*[@id="site-content"]/div[2]/div/div[2]/div/div[1]/button[2]'
    elem_d = driver.find_element(by=By.XPATH, value=d_cell)
    elem_d.click()

def saveimg():
    driver.save_screenshot('result.png')
    #img = Image('result.png')
    #img

def autoad():
    addcell()
    time.sleep(5)
    deletecell()
    time.sleep(5)
    saveimg()

def autofwawt():
    whc=0
    with open("now_print1.out","w") as f:
        f.write(f"{whc}|")
    while True:
        #print(whc,end="|")
        with open("now_print1.out","a+") as fw:
            fw.write(f"{whc}|")
        whc+=1
        autoad()
        time.sleep(180)

saveimg()

##part2##
autofwawt()
#import threading
#t = threading.Thread(target=autofwawt)
#t.daemon = True
#t.start()