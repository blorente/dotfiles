import logging

# Log level for trace logs.
TRACE_LOG_LEVEL = 5


def add_logging_to_arg_parser(parser):
    parser.add_argument(
        "-l",
        "--log",
        dest="log_level",
        choices=["trace", "debug", "info", "warning", "error", "critical"],
        help="Set the logging level",
        default="info",
    )


def _trace(self, message, *args, **kws):
    if self.isEnabledFor(TRACE_LOG_LEVEL):
        # Yes, logger takes its '*args' as 'args'.
        self._log(TRACE_LOG_LEVEL, message, args, **kws)


def configure_logging(log, args):
    """Sets up logging (surprisingly complex)."""
    # https://stackoverflow.com/questions/2183233/how-to-add-a-custom-loglevel-to-pythons-logging-facility
    logging.addLevelName(TRACE_LOG_LEVEL, "TRACE")

    logging.Logger.trace = _trace

    log_level = logging.getLevelName(args.log_level.upper())
    log.setLevel(log_level)
    ch = logging.StreamHandler()
    ch.setLevel(log_level)
    ch.setFormatter(_CustomFormatter())
    log.addHandler(ch)


class _CustomFormatter(logging.Formatter):
    """Logging Formatter to add colors and count warning / errors"""

    light_grey = "\x1b[38;5;242m"
    grey = "\x1b[38;5;251m"
    yellow = "\x1b[38;5;226m"
    red = "\x1b[38;5;196m"
    blue = "\x1b[38;5;45m"
    bold_red = "\x1b[1;38;5;196m"
    reset = "\x1b[0m"
    format = "%(name)s:%(lineno)-3d%(levelname)8s: %(message)s"

    FORMATS = {
        TRACE_LOG_LEVEL: light_grey + format + reset,
        logging.DEBUG: grey + format + reset,
        logging.INFO: blue + format + reset,
        logging.WARNING: yellow + format + reset,
        logging.ERROR: red + format + reset,
        logging.CRITICAL: bold_red + format + reset,
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)
