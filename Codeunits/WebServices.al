codeunit 50550 WebServices
{
    trigger OnRun()
    begin
    end;

    procedure Ping(): Text
    begin
        exit('Pong');
    end;

    procedure GetItemsToJson(jsontext: Text): Text
    var
        Item: Record Item;
        JsonInput: JsonObject;
        JSONProperty: JsonObject;
        ItemNoToken: JsonToken;
        BigText: Text;
    begin
        JsonInput.ReadFrom(jsontext);

        if not JsonInput.Get('No', ItemNoToken) then begin
            Error('Error reading Item No');
        end;

        Item.SetRange("No.", ItemNoToken.AsValue().AsCode());
        if not Item.FindLast() then begin
            JSONProperty.Add('Error', StrSubstNo('Item No. %1 not found', ItemNoToken.AsValue().AsCode()));
            JSONProperty.WriteTo(BigText);
            exit(BigText);
        end;

        JSONProperty.Add('No', Item."No.");
        JSONProperty.Add('Description', Item.Description);
        JSONProperty.Add('UnitPrice', Item."Unit Price");
        JSONProperty.Add('UnitCost', Item."Unit Cost");
        JSONProperty.Add('UnitOfMeasure', Item."Base Unit of Measure");

        JSONProperty.WriteTo(BigText);

        exit(BigText);
    end;
}