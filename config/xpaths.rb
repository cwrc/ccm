#This file contains XPATH definitions for various elements

ENTITY_TYPE_PATH = "/entity/*"
ENTITY_PREFERRED_FORM_NAMES_PATH = "/entity/*/identity/preferredForm/namePart"
ENTITY_SURNAME_PATH = '/entity/*/identity/preferredForm/namePart[@partType="surname"]'
ENTITY_FORENAME_PATH = '/entity/*/identity/preferredForm/namePart[@partType="forename"]'
ENTITY_DISPLAY_NAME_PATH = '/entity/*/identity/preferredForm/displayForm'
