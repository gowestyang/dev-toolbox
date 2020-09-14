# Author: Yang Xi
# Date Created: 2019-02-07
# Date Modified: 2020-07-03 

import logging
import pandas as pd
from datetime import datetime

logging.addLevelName(39, 'ERR')
logging.ERR = 39

class logger():
    def __init__(self, logFile='', application='', append=False, defaultPath='C:/app/log/'):
        assert logFile!='' or application!='', 'Error: must input either logFile or application'
        if logFile=='':
            pathLog = defaultPath
            dateLog = datetime.today().strftime('%Y%m%d')
            logFile = pathLog + application + '_' + dateLog + '.log'
        self.logFile = logFile
        self.logger = logging.getLogger()
        self.logger.handlers = []
        self.logHdlr = logging.FileHandler(self.logFile)
        self.logHdlr.setFormatter(logging.Formatter('%(asctime)s %(levelname)s %(message)s'))
        self.logger.addHandler(self.logHdlr)
        self.logger.setLevel(logging.INFO)
        if not append:
            with open(self.logFile, 'w'):
                pass

    def clearLog(self):
        with open(self.logFile, 'w'):
            pass

    def logPrint(self, msg, level=logging.INFO):
        if type(msg) in [pd.Series, pd.DataFrame]: msg = '\n'+msg.to_string()
        self.logger.log(level, msg)
        print(msg)
        self.logHdlr.close()

    

