SELECT
    st.Name,
    COUNT(*) AS TimesUsed
FROM Shipment s
JOIN ServiceType st ON s.ServiceTypeID = st.ServiceTypeID
GROUP BY st.Name
ORDER BY TimesUsed DESC;