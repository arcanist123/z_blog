CLASS zblog_service_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS get_default_service
      RETURNING
        VALUE(ro_message_service) TYPE REF TO zblog_service_provider.
    METHODS add_sy.
    METHODS get_messages_bapiret
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_message,
        type       TYPE symsgty,
        id         TYPE symsgid,
        number     TYPE symsgno,
        message    TYPE string,
        message_v1 TYPE string,
        message_v2 TYPE string,
        message_v3 TYPE string,
        message_v4 TYPE string,
      END OF ts_message.
    TYPES tt_messages TYPE STANDARD TABLE OF ts_message
        WITH DEFAULT KEY
        WITH NON-UNIQUE SORTED KEY type_key COMPONENTS type.
    CLASS-DATA go_default_service TYPE REF TO zblog_service_provider.
    DATA gt_messages TYPE tt_messages.
ENDCLASS.



CLASS zblog_service_provider IMPLEMENTATION.

  METHOD get_default_service.
    IF go_default_service IS NOT BOUND.
      go_default_service = NEW #( ).
    ENDIF.
    ro_message_service = go_default_service.

  ENDMETHOD.

  METHOD add_sy.
    "get the message text
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
          INTO DATA(lv_msg_text).
    "save the entry
    APPEND VALUE ts_message(
        type        = sy-msgty
        id          =  sy-msgid
        message     = lv_msg_text
        message_v1  = sy-msgv1
        message_v2  = sy-msgv2
        message_v3  = sy-msgv3
        message_v4  = sy-msgv4
        number      = sy-msgno ) TO me->gt_messages.
  ENDMETHOD.

  METHOD get_messages_bapiret.
    rt_messages = VALUE bapiret2_t(
        FOR <wa> IN gt_messages (
            id          = <wa>-id
            message     = <wa>-message
            message_v1  = <wa>-message_v1
            message_v2  = <wa>-message_v2
            message_v3  = <wa>-message_v3
            message_v4  = <wa>-message_v4
            number      = <wa>-number
            type        = <wa>-type ) ).

  ENDMETHOD.

ENDCLASS.
