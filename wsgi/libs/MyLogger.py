"""オリジナルロガー."""
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

formatter = logging.Formatter(
    '%(asctime)s [%(levelname)07s][%(process)d] - %(message)s [%(filename)s:%(lineno)d]'
)

stream = logging.StreamHandler()
stream.setFormatter(formatter)

logger.addHandler(stream)
