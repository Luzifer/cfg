import html
import os

BTN_LEFT = 1
BTN_MIDDLE = 2
BTN_RIGHT = 3

COLOR_NONE = '#ffffff'
COLOR_DANGER = '#dd0000'
COLOR_SUCCESS = '#50fa7b'
COLOR_WARNING = '#ffd966'
COLOR_PRIMARY = '#8faafc'
COLOR_SECONDARY = '#7f7f7f'

VAR_BTN = 'BLOCK_BUTTON'
VAR_INSTANCE = 'BLOCK_INSTANCE'
VAR_NAME = 'BLOCK_NAME'
VAR_X = 'BLOCK_X'
VAR_Y = 'BLOCK_Y'


class Block:
    def __init__(self, icon=None, icon_color=None):
        self.ICON = icon if icon is not None else '\uf128'
        self.ICON_COLOR = icon_color if icon_color is not None else COLOR_NONE

    def button_is(self, btn):
        """
        Checks whether a button was pressed on the widget and if so whether it was the expected one
        """
        return VAR_BTN in os.environ and os.environ[VAR_BTN] != '' and int(os.environ[VAR_BTN]) == btn

    def color_text(self, text, color=COLOR_NONE):
        """
        Formats the given text with given color in pango markup
        """
        return '<span color="{color}">{text}</span>'.format(
            color=color,
            text=text,
        )

    def execute(self):
        """
        Contains the logic of this block and needs to be overwritten in child class
        """
        raise Exception('No exec implementation specified')

    def instance(self):
        """
        Returns the block-defined instance or empty string if none
        """
        return os.environ[VAR_INSTANCE] if VAR_INSTANCE in os.environ else ''

    def name(self):
        """
        Returns the block-defined name or empty string if none
        """
        return os.environ[VAR_NAME] if VAR_NAME in os.environ else ''

    def render(self):
        """
        Executes the block and prints out the formatted string for the block
        """
        result = self.execute()

        if result is None or len(result) == 0:
            print(self.color_text(self.ICON, self.ICON_COLOR))
            return

        text = ''
        if type(result) is list:
            text = ' '.join(result)
        else:
            text = result

        print('{icon}  {text}'.format(
            icon=self.color_text(self.ICON, self.ICON_COLOR),
            text=text,
        ))

    def safe_text(self, text):
        return html.escape(text)

    def set_icon(self, icon):
        """
        Overwrites the icon speicfied in constructor
        """
        self.ICON = icon

    def set_icon_color(self, color):
        """
        Overwrites the icon color speicfied in constructor
        """
        self.ICON_COLOR = color
