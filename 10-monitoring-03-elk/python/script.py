#!/usr/bin/env python3

import time
import random
import logging

while True:
    t = time.localtime()
    number = random.randrange(0, 3, 1)
    cur_time = time.strftime("%Y/%m/%d -- %H:%M:%S -", t)
    if number == 0:
        logging.info("%s [INFO] - This message logged just now" % (cur_time))
        time.sleep(2)
        continue
    if number == 1:
        logging.warning("%s [WARN] - This message logged with some warning" % (cur_time))
        time.sleep(2)
        continue
    if number == 2:
        logging.error("%s [ERROR] - This message logged with occured error" % (cur_time))
        time.sleep(2)
        continue