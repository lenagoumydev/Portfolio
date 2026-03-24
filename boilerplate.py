import os,pathlib,sys,subprocess,time

try:
    os.makedirs(f"topology-{sys.argv[1]}/routers")
    os.makedirs(f"topology-{sys.argv[1]}/docs")
    os.makedirs(f"topology-{sys.argv[1]}/switches")
except:
    pass
finally:
    #subprocess.run(args=["rm", "-r",f"topology-{sys.argv[1]}"])
    pass
