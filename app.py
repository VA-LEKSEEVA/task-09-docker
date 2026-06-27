import time
import os
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
log = logging.getLogger("worker")

INTERVAL = int(os.environ.get("INTERVAL", "5"))

def main():
    log.info(f"Worker started, interval={INTERVAL}s")
    counter = 0
    while True:
        counter += 1
        log.info(f"tick #{counter}")
        time.sleep(INTERVAL)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        log.info("Bye!")
