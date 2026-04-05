SELECT COUNT(*) AS ActiveDeliveryCount
FROM vw_ActiveShipments
WHERE EstimatedDeliveryDate >= GETDATE();
