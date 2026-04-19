package com.studyroom.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.Reservation;
import com.studyroom.mapper.ReservationMapper;
import com.studyroom.service.ReservationService;
import org.springframework.stereotype.Service;

@Service
public class ReservationServiceImpl extends ServiceImpl<ReservationMapper, Reservation> implements ReservationService {

}
