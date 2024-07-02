from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

class VouchersLibrary:

    def __init__(self):
        self.seleniumlib = BuiltIn().get_library_instance('SeleniumLibrary')

    @keyword
    def get_text(self, locator):
        return self.seleniumlib.get_text(locator)

    @keyword
    def click_link(self, locator):
        self.seleniumlib.click_link(locator)

    @keyword
    def input_text(self, locator, text):
        self.seleniumlib.input_text(locator, text)

    @keyword
    def click_button(self, locator):
        self.seleniumlib.click_button(locator)
