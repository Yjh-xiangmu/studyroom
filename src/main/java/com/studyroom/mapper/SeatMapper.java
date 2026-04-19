package com.studyroom.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.studyroom.entity.Seat;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SeatMapper extends BaseMapper<Seat> {

    @Select("SELECT * FROM seat WHERE room_id = #{roomId} ORDER BY row_num, col_num")
    List<Seat> selectByRoomId(@Param("roomId") Long roomId);

}
