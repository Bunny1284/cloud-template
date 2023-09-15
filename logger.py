# stream handler
import logging
from pythonjsonlogger import jsonlogger


logger = logging.getLogger()
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter()
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)

# file handler store in logs folder
# json formant
# file rotation for 10 mb (file name time stamp)