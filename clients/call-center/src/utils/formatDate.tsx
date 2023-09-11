export const formatDate = (localTime: any) => {
    // Create a Date object from the local time string
    const localDate = new Date(localTime);

    // Set the time zone to Vietnam (Indochina Time - ICT)
    localDate.toLocaleString("en-US", { timeZone: "Asia/Ho_Chi_Minh" });

    // Format the date and time as "HH:mm - DD/MM/YYYY"
    const formattedDate = localDate.toLocaleTimeString("en-US", {
    timeZone: "Asia/Ho_Chi_Minh",
    hour: "2-digit",
    minute: "2-digit",
    }) + " - " + swapDayAndMonth(localDate.toLocaleDateString("en-US", {
    timeZone: "Asia/Ho_Chi_Minh",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    }));

    return formattedDate;
}


// Hàm để đổi chỗ ngày và tháng trong định dạng "DD/MM/YYYY"
export const swapDayAndMonth = (dateString: string) => {
    const [day, month, year] = dateString.split("/");
    return `${month}/${day}/${year}`;
  }