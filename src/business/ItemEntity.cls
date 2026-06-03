/*------------------------------------------------------------------------
  File        : ItemEntity
  Purpose     : Business Entity for Item data access
  Syntax      : 
  Description : 
  Author(s)   : 
  Created     : 
  Notes       : 
----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS business.ItemEntity INHERITS BusinessEntity USE-WIDGET-POOL:
    
    /* Include dataset definition */
    {business/ItemDataset.i}
    
    /* Define data sources */
    DEFINE DATA-SOURCE srcItem FOR Item.
    
    /*------------------------------------------------------------------------------
     Purpose: Constructor for ItemEntity
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ItemEntity():
        SUPER(DATASET dsItem:HANDLE).

        VAR HANDLE[1] hDataSourceArray = DATA-SOURCE srcItem:HANDLE.
        VAR CHARACTER[1] cSkipListArray = [""].
        
        /* Data Source for each table in dataset */
        THIS-OBJECT:ProDataSource = hDataSourceArray.
        /* Skip-list entry for each table in dataset */
        THIS-OBJECT:SkipList = cSkipListArray.
    END CONSTRUCTOR.
    
    /*------------------------------------------------------------------------------
     Purpose: Get item by item number
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL GetItemByNumber(INPUT ipiItemNum AS INTEGER,
                                           OUTPUT DATASET dsItem):
        VAR CHARACTER cFilter.
        VAR LOGICAL lFound = FALSE.
        
        /* Build filter for item number */
        cFilter = "WHERE Item.ItemNum = " + STRING(ipiItemNum).
        
        /* Read data using filter */
        THIS-OBJECT:ReadData(cFilter).
    
        /* Check if item was found */
        lFound = CAN-FIND(FIRST ttItem).
        
        RETURN lFound.
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: Update item data
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID UpdateItem(INPUT-OUTPUT DATASET dsItem):
        /* Update data in database */
        THIS-OBJECT:UpdateData(DATASET dsItem BY-REFERENCE).
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: Validate item data
     Notes: Checks price > 0 and total on-hand value <= 6000
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL ValidateItem(INPUT-OUTPUT DATASET dsItem,
                                        OUTPUT opcErrorMessage AS CHARACTER):
        VAR LOGICAL lIsValid = TRUE.
        
        /* Find the first item in the dataset */
        FIND FIRST ttItem NO-ERROR.
        IF AVAILABLE ttItem THEN DO:
            /* Validate price is greater than zero */
            IF ttItem.Price <= 0 THEN DO:
                lIsValid = FALSE.
                opcErrorMessage = "Price cannot be zero or negative".
            END.
            ELSE IF (ttItem.OnHand * ttItem.Price) > 6000 THEN DO:
                lIsValid = FALSE.
                opcErrorMessage = SUBSTITUTE("Total value on hand (&1) should not be larger than 6000",
                                             ttItem.OnHand * ttItem.Price).
            END.
        END.
        
        RETURN lIsValid.
    END METHOD.

END CLASS.
