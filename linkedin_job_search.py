import time
import os
import random
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC

options = Options()
options.add_argument("--headless")  # If you want to run Chrome in headless mode
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--remote-debugging-port=9222")

# Set up the WebDriver using Service and ChromeDriverManager
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)

# Function to log in to LinkedIn
def login_to_linkedin(username, password):
    driver.get("https://www.linkedin.com/login")
    time.sleep(3)
    
    driver.find_element(By.ID, "username").send_keys(username)
    driver.find_element(By.ID, "password").send_keys(password)
    driver.find_element(By.XPATH, "//button[@type='submit']").click()

    time.sleep(5)  # Wait for the login to complete
    print('Logged in Successfuly!')

# Function to search for jobs
def search_jobs(keyword, location):
    # Go to the LinkedIn Jobs section
    driver.get("https://www.linkedin.com/jobs/")
    time.sleep(3)
    
    search_box = driver.find_element(By.XPATH, "//input[@aria-label='Search by title, skill, or company']")
    search_box.send_keys(keyword)
    
    time.sleep(2)

    location_box = driver.find_element(By.XPATH, "//input[@aria-label='City, state, or zip code']")
    location_box.clear()
    location_box.send_keys(location)
    
    # Hit Enter to initiate the search
    location_box.send_keys(Keys.RETURN)
    time.sleep(5)  # Wait for search results to load


# Function to extract job listings
def extract_job_listings():
    # Find all job cards in the search results
    job_cards = driver.find_elements(By.CLASS_NAME, "scaffold-layout__list-container")
    # job_cards = driver.find_elements(By.CLASS_NAME, "scaffold-layout__list-detail")

    time.sleep(3)
    # Print the current URL after hitting enter
    job_search_url = driver.current_url
    print(f"job_search URL after search: {job_search_url}")
    
    job_listings = []

    for job_card in job_cards:
        title = job_card.text
        link = job_card.find_element(By.TAG_NAME, 'a').get_attribute("href")
        job_listings.append({"Title": title, "Link": link})
        print("\n")
    
    return job_listings

# Main function to run the script
def main():
    username = os.getenv('LINKEDIN_USERNAME')
    password = os.getenv('LINKEDIN_PASSWORD')
    
    keyword = "python"
    location = "Germany"

    print("Country Selected:", location)

    # Log in to LinkedIn
    login_to_linkedin(username, password)

    # Search for jobs
    search_jobs(keyword, location)

    # Extract job listings
    jobs = extract_job_listings()

    # Print the job listings
    if jobs:
        print(f"Found {len(jobs)} jobs:")
        for job in jobs:
            print(f"Title: {job['Title']}, Link: {job['Link']}")
    else:
        print("No job listings found.")

# Run the script
if __name__ == "__main__":
    main()
